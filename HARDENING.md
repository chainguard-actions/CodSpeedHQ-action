<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 27 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions are interpolated directly inside run: shell command strings (rule a). In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` is assigned directly to a shell variable and `${{ inputs.mode }}` is used in a command substitution. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are all interpolated directly into shell commands. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell commands. Any of these values could contain shell metacharacters that would be interpreted by the shell before execution.

Locations:

- `action.yml:100`
- `action.yml:133`
- `action.yml:160`
- `action.yml:161`
- `action.yml:163`
- `action.yml:196`
- `action.yml:218`
- `action.yml:224`
- `action.yml:228`
- `action.yml:232`
- `action.yml:236`
- `action.yml:240`
- `action.yml:244`
- `action.yml:248`
- `action.yml:252`
- `action.yml:256`
- `action.yml:260`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths: (1) for the 'latest' version type: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`, and (2) for the 'prerelease' version type: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`. In both cases the remote script is not downloaded to a file first for inspection or hash verification before execution. An attacker who can influence the remote endpoint or perform a MITM attack could execute arbitrary code on the runner.

Locations:

- `action.yml:175`
- `action.yml:183`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the untrusted input `${{ inputs.mode }}` is interpolated directly into a shell command to compute MODE_CACHE_KEY (`MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`), and the result is then written to $GITHUB_OUTPUT (`echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`) without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline character embedded in the mode input could inject arbitrary key=value pairs into the GitHub output environment.

Locations:

- `action.yml:133`
- `action.yml:134`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:97`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:130`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:229`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:236`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:237`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:239`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:240`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:245`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:248`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:251`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:264`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unsafe-shell, github-env-injection, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.) instead of interpolating GitHub expressions directly.

2. **unsafe-shell**: Fixed both curl | bash patterns in the 'Install CodSpeed runner' step. For 'latest' and 'prerelease' version types, the script now downloads the installer to a temp file with `curl -fsSL ... -o "$INSTALLER_TMP"` and then executes it separately with `bash "$INSTALLER_TMP" --quiet`, matching the pattern already used for release versions.

3. **github-env-injection**: Fixed the MODE_CACHE_KEY computation in 'Determine runner and kernel version' to use `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'` instead of `echo "${{ inputs.mode }}" | tr ',' '-'`, preventing newline injection into GITHUB_OUTPUT. The ${{ inputs.mode }} expression was also moved to the env: block as INPUT_MODE.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in the 'Determine runner and kernel version' step of action.yml. The RUNNER_VERSION variable (derived from user-controlled input `inputs.runner-version`) was written to $GITHUB_OUTPUT without newline sanitization. Applied `printf '%s' "$VAR" | tr -d '\n\r'` sanitization to all four $GITHUB_OUTPUT writes in the step (runner-version, version-type, kernel-version, and mode-cache-key — the last one was already sanitized). This prevents an attacker-controlled value containing a newline from injecting additional key=value pairs into GITHUB_OUTPUT.

### Iteration 3

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all three findings:
1. script-injection in bump-runner-version.yml: Moved `${{ github.event.inputs.version }}` into an env var `INPUT_VERSION` and replaced all four inline interpolations in the run block with `$INPUT_VERSION`/`${INPUT_VERSION}`.
2. unpinned-uses: Pinned all 9 occurrences of `actions/checkout@v4` to `actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4` in both bump-runner-version.yml (1 occurrence) and ci.yml (8 occurrences).
3. missing-permissions in ci.yml: Added top-level `permissions: contents: read` block.

### Iteration 4

**Fixes applied:** script-injection

**Notes:**

Fixed three unquoted shell variable expansions in .github/workflows/bump-runner-version.yml:
1. Line ~51: `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`
2. Line ~53: `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`
3. Line ~58: `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`
4. Also fixed the `--head $BRANCH_NAME` argument in the `gh pr create` command on the same line as the push.

All variables ($BRANCH_NAME and $VERSION) are derived from `github.event.inputs.version` (a workflow_dispatch input), so they are workflow-controllable data. Double-quoting prevents shell metacharacter interpretation while keeping the values intact.

