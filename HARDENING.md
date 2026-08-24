<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 34 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in the 'Determine runner and kernel version' step. The expressions `${{ inputs.runner-version }}`, `${{ runner.os }}`, and `${{ inputs.mode }}` are interpolated directly into shell command strings before the shell ever sees them, allowing an attacker-controlled value to inject arbitrary shell commands. Example offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"`, `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:100`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in the 'Install CodSpeed runner' step. The expressions `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are all interpolated directly into shell command strings. Example offending lines: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:161`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in the 'Run the benchmarks' step. Over a dozen `inputs.*` expressions are interpolated directly into shell command strings, including: `${{ inputs.mode }}` (in an `if [ -z ... ]` test), `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}`, and `${{ inputs.simulation-track-subprocess }}`. Any of these can contain shell metacharacters that execute arbitrary commands.

Locations:

- `action.yml:222`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes untrusted input values to $GITHUB_OUTPUT without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written as `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no `printf '%s' | tr -d '\n\r'` sanitization. (2) `DISTRO` is set from `${{ runner.os }}` (a workflow-template-substituted value) and written as `echo "distro=$DISTRO" >> $GITHUB_OUTPUT` without sanitization. (3) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written as `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline in any of these values could inject arbitrary environment variables or outputs.

Locations:

- `action.yml:100`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths: (1) For the 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the script is fetched and executed in a single pipeline without downloading to a file first for inspection or hash verification. (2) For 'prerelease' versions: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern. If the remote server is compromised or the URL is intercepted, arbitrary code executes on the runner.

Locations:

- `action.yml:183`
- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:116`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:296`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Rewrote action.yml to fix all security findings:

1. **script-injection / static-inline-injection**: Moved all ${{ }} expressions from run: blocks to env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.) instead of direct template interpolation.

2. **github-env-injection**: Values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. Applied to runner-version, distro, and mode-cache-key outputs.

3. **unsafe-shell**: Converted both `curl | bash` patterns to download-then-execute:
   - 'latest': `curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"` then `bash "$INSTALL_SCRIPT" --quiet`
   - 'prerelease': `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" -o "$INSTALL_SCRIPT"` then `bash "$INSTALL_SCRIPT" --quiet`
   The `--` before `--quiet` was correctly dropped (it was the shell's stdin option terminator, not the script's argument separator).

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

Fixed script injection in bump-runner-version.yml by moving `${{ github.event.inputs.version }}` into an env variable `INPUT_VERSION` and referencing it as `$INPUT_VERSION` throughout the run script. Pinned all 9 occurrences of `actions/checkout@v4` to the full commit SHA `11d5960a326750d5838078e36cf38b85af677262` with a `# v4` comment for readability (1 in bump-runner-version.yml, 8 in ci.yml).

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed all four unquoted variable expansions in .github/workflows/bump-runner-version.yml:
1. `BRANCH_NAME=bump-runner-version/$VERSION` → `BRANCH_NAME="bump-runner-version/$VERSION"` (assignment now quoted)
2. `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`
3. `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`
4. `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`
5. `gh pr create ... --head $BRANCH_NAME` → `gh pr create ... --head "$BRANCH_NAME"`
All workflow-controllable variables derived from github.event.inputs.version are now properly double-quoted throughout the shell script.

