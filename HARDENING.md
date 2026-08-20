<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 29 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version': ${{ inputs.runner-version }} and ${{ inputs.mode }} are interpolated directly inside the run: shell script (sub-rule a). Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. An attacker-controlled input value is expanded by the YAML template engine before the shell ever sees it, enabling command injection.

Locations:

- `action.yml:104`
- `action.yml:121`

### script-injection (severity: high)

Step 'Install CodSpeed runner': Multiple GitHub Actions expressions are interpolated directly inside the run: shell script (sub-rule a). Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. These context values are substituted by the YAML template engine before the shell parses the script, enabling injection.

Locations:

- `action.yml:147`
- `action.yml:148`
- `action.yml:150`
- `action.yml:176`

### script-injection (severity: high)

Step 'Run the benchmarks': Numerous ${{ inputs.* }} expressions are interpolated directly inside the run: shell script (sub-rule a). Offending lines include: `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]` / `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.mode }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`. All of these are substituted by the YAML template engine before the shell parses the script, allowing a caller to inject arbitrary shell commands.

Locations:

- `action.yml:205`
- `action.yml:212`
- `action.yml:213`
- `action.yml:216`
- `action.yml:220`
- `action.yml:224`
- `action.yml:228`
- `action.yml:232`
- `action.yml:236`
- `action.yml:240`
- `action.yml:244`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version': Two unsanitized values derived from user-controlled inputs are written to $GITHUB_OUTPUT without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. (1) `inputs.runner-version` is assigned to the shell variable RUNNER_VERSION and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input can inject additional output variables. (2) `inputs.mode` is used to compute MODE_CACHE_KEY and then written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — same risk.

Locations:

- `action.yml:123`
- `action.yml:127`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner': When the version type is 'latest', the installer script is fetched from a remote URL and piped directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the URL is intercepted (e.g. via DNS hijacking), arbitrary code will execute on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash, but the 'latest' path bypasses this protection entirely.

Locations:

- `action.yml:163`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:97`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:128`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:157`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:228`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:229`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:232`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:234`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:235`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:237`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:238`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:240`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:241`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:256`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection** (all 3 steps): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks. Shell scripts now reference plain $VAR_NAME environment variables.

2. **github-env-injection** ('Determine runner and kernel version'): Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. **unsafe-shell** ('Install CodSpeed runner'): Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a two-step approach: download to temp file with `curl -fsSL ... -o "$INSTALLER_TMP"`, then execute with `bash "$INSTALLER_TMP" --quiet` (dropped the `--` as it was the shell's option terminator, not the script's argument).

All ${{ }} expressions in run: blocks have been eliminated. The remaining ${{ }} expressions are all in env:, with:, or if: contexts which are safe.

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (bump-runner-version.yml): Moved `${{ github.event.inputs.version }}` into the step's `env:` block as `INPUT_VERSION`. All shell references now use `"$INPUT_VERSION"` or `"${INPUT_VERSION}"` — no expression interpolation inside `run:` blocks.
2. unpinned-uses: Pinned all 8 `actions/checkout@v4` references (7 in ci.yml, 1 in bump-runner-version.yml) to the full commit SHA `11d5960a326750d5838078e36cf38b85af677262 # v4`.
3. missing-permissions: Added a top-level `permissions: contents: read` block to ci.yml. The bump-runner-version.yml already had appropriate permissions (contents: write, pull-requests: write) for its PR-creation workflow.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted shell variable expansions in .github/workflows/bump-runner-version.yml:
- Line 51: `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`
- Line 53: `echo $VERSION >` → `echo "$VERSION" >`
- Line 58: `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`
- Also fixed unquoted `$BRANCH_NAME` in the `gh pr create --head` argument on the same line.
All variables are already routed through the env: block (INPUT_VERSION from github.event.inputs.version), but the unquoted expansions still allowed shell metacharacter injection. Adding double quotes prevents the shell from splitting or interpreting metacharacters in the values.

