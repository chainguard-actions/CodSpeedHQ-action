<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings across three steps in action.yml, allowing an attacker-controlled input to inject arbitrary shell commands.

Step 'Determine runner and kernel version': `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs are interpolated directly into the shell before quoting can protect them.

Step 'Install CodSpeed runner': `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly into the shell script.

Step 'Run the benchmarks': `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` — all inputs interpolated directly into the shell.

All of these should be routed through env: variables and then referenced as quoted shell variables (e.g., "$VAR") instead.

Locations:

- `action.yml:99`
- `action.yml:120`
- `action.yml:145`
- `action.yml:146`
- `action.yml:148`
- `action.yml:175`
- `action.yml:202`
- `action.yml:209`
- `action.yml:211`
- `action.yml:214`
- `action.yml:217`
- `action.yml:220`
- `action.yml:223`
- `action.yml:226`
- `action.yml:229`
- `action.yml:232`
- `action.yml:235`

### github-env-injection (severity: high)

Values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization (no `printf '%s' ... | tr -d '\n\r'` step applied before the write).

In the 'Determine runner and kernel version' step:
- `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`
- `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`

An attacker-controlled value containing newlines could inject additional key=value pairs into $GITHUB_OUTPUT, potentially overwriting subsequent step outputs and influencing downstream behavior.

Locations:

- `action.yml:121`
- `action.yml:122`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash without first saving it to a file for inspection: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the URL is intercepted (e.g., via DNS hijacking or MITM), arbitrary code will be executed on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' version path bypasses this protection entirely.

Locations:

- `action.yml:153`

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

Fixed all findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks for the three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference safe environment variables like $INPUT_MODE, $INPUT_TOKEN, $INPUT_RUNNER_VERSION, etc.

2. github-env-injection: Sanitized the two GITHUB_OUTPUT writes that were derived from user inputs. Used `printf '%s' "$VAR" | tr -d '\n\r'` to strip newlines from runner-version and mode-cache-key before writing them to $GITHUB_OUTPUT.

3. unsafe-shell: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a download-then-execute pattern: download to a temp file with `curl -fsSL ... -o "$INSTALL_SCRIPT_TMP"`, then execute with `bash "$INSTALL_SCRIPT_TMP" --quiet`. The `--` was dropped (it was the shell's stdin-option terminator for the pipe form, not an argument to the install script itself).

