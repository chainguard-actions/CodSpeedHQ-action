<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` are directly interpolated inside `run:` shell command strings across three steps, allowing an attacker to inject arbitrary shell commands.

**Step 1 – "Determine runner and kernel version"** (line ~97):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — user-controlled input interpolated directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — user-controlled input interpolated directly into shell

**Step 2 – "Install CodSpeed runner"** (line ~135):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step 3 – "Run the benchmarks"** (line ~204):
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]` → `RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `if [ -n "${{ inputs.working-directory }}" ]` → `--working-directory="${{ inputs.working-directory }}"`
- `if [ -n "${{ inputs.upload-url }}" ]` → `--upload-url="${{ inputs.upload-url }}"`
- `if [ -n "${{ inputs.mode }}" ]` → `--mode="${{ inputs.mode }}"`
- `if [ -n "${{ inputs.instruments }}" ]` → `--instruments="${{ inputs.instruments }}"`
- `if [ -n "${{ inputs.mongo-uri-env-name }}" ]` → `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
- `if [ "${{ inputs.cache-instruments }}" = "true" ]` and `if [ -n "${{ inputs.instruments-cache-dir }}" ]` → `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `if [ -n "${{ inputs.go-runner-version }}" ]` → `--go-runner-version="${{ inputs.go-runner-version }}"`
- `if [ -n "${{ inputs.config }}" ]` → `--config="${{ inputs.config }}"`

All of these should be routed through `env:` variables and then double-quoted in the shell.

Locations:

- `action.yml:97`
- `action.yml:118`
- `action.yml:135`
- `action.yml:136`
- `action.yml:138`
- `action.yml:175`
- `action.yml:204`
- `action.yml:211`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted `inputs.*` are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~97) and then written unsanitized: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~113). A newline in the input value could inject additional key=value pairs into the output file.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which does NOT strip newlines) and then written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~119).

The fix requires sanitizing before each write: `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` then `echo "key=$safe" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yml:113`
- `action.yml:119`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the script pipes a remote shell script directly to bash without first downloading it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the `latest` path.

Locations:

- `action.yml:148`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all three affected steps in action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell strings into env: blocks. Step 1 ('Determine runner and kernel version') uses INPUT_RUNNER_VERSION and INPUT_MODE. Step 3 ('Install CodSpeed runner') uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH. Step 4 ('Run the benchmarks') uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG.

2. **github-env-injection**: Both GITHUB_OUTPUT writes in step 1 now sanitize with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. GITHUB_OUTPUT references are also properly double-quoted.

3. **unsafe-shell**: Replaced `curl ... | bash -s -- --quiet` with download-then-execute: `curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"` then `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped as it was the shell's option terminator, not the script's argument.

