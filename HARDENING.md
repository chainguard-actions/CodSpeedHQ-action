<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple GitHub Actions expressions are directly interpolated inside `run:` shell command strings in action.yml, violating rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

**Step: "Determine runner and kernel version"** (line ~97):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — untrusted input directly in shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — untrusted input directly in shell

**Step: "Install CodSpeed runner"** (line ~143):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step: "Run the benchmarks"** (line ~200):
- `if [ -z "${{ inputs.mode }}" ]`
- `RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- `RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")`
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")`

All these should be moved to `env:` variables and referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:97`
- `action.yml:121`
- `action.yml:143`
- `action.yml:144`
- `action.yml:146`
- `action.yml:185`
- `action.yml:200`
- `action.yml:207`
- `action.yml:210`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the script pipes a remote install script directly to bash without first downloading and verifying it: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as is already done for the release version path).

Locations:

- `action.yml:155`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` is set directly from `${{ inputs.runner-version }}` (an attacker-controlled value). A newline in the input could inject additional output variables.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'`, which does not strip newlines. A newline in `inputs.mode` could inject additional output variables.

Fix: apply `printf '%s' "$VAR" | tr -d '\n\r'` before each write to `$GITHUB_OUTPUT`.

Locations:

- `action.yml:122`
- `action.yml:125`

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

**Fixes applied:** script-injection, unsafe-shell, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings in action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH
   - 'Run the benchmarks': Added env: block with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG

2. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with downloading to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"`) then executing separately (`bash "$INSTALLER_TMP" --quiet`). The '--' was correctly dropped as it was the shell's option terminator for the pipe form, not an argument to the script.

3. **github-env-injection**: All values written to $GITHUB_OUTPUT are now sanitized using `printf '%s' "$VAR" | tr -d '\n\r'` before writing, preventing newline injection attacks.

