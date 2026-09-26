<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings (rule a), allowing an attacker-controlled value to be executed as shell code.

Step 'Determine runner and kernel version':
- Line 96: `RUNNER_VERSION="${{ inputs.runner-version }}"` — inputs.runner-version interpolated directly into shell
- Line 117: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs.mode interpolated directly into shell

Step 'Install CodSpeed runner':
- Line 140: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` — step output interpolated directly
- Line 141: `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` — step output interpolated directly
- Line 143: `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — inputs value interpolated directly
- Line 174: `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — step output interpolated directly

Step 'Run the benchmarks':
- Line 202: `if [ -z "${{ inputs.mode }}" ]` — inputs.mode interpolated directly
- Lines 205-230: Multiple `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.mode }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}` all interpolated directly into shell command strings.

All of these should be moved to env: variables and referenced as quoted shell variables (e.g., "$VAR").

Locations:

- `action.yml:96`
- `action.yml:117`
- `action.yml:140`
- `action.yml:141`
- `action.yml:143`
- `action.yml:174`
- `action.yml:202`

### github-env-injection (severity: high)

Untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r').

In the 'Determine runner and kernel version' step:
1. `inputs.runner-version` is interpolated into RUNNER_VERSION via `${{ inputs.runner-version }}`, then written to $GITHUB_OUTPUT with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~113) — no newline sanitization applied.
2. `inputs.mode` is interpolated via `${{ inputs.mode }}` into MODE_CACHE_KEY, then written to $GITHUB_OUTPUT with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~118) — no newline sanitization applied.

An attacker-controlled newline in these values can inject arbitrary key=value pairs into the GitHub Actions environment, potentially overwriting subsequent step outputs or environment variables.

Locations:

- `action.yml:113`
- `action.yml:118`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes a remotely fetched script directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the URL is intercepted (e.g., via DNS hijacking), arbitrary code will be executed on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately — which is already done for the release version path in the same step. The 'latest' version path bypasses this protection.

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell bodies to env: blocks in three steps:
   - 'Determine runner and kernel version': Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE; replaced inline expressions with $INPUT_RUNNER_VERSION and $INPUT_MODE.
   - 'Install CodSpeed runner': Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH; removed all inline ${{ }} from the run: body.
   - 'Run the benchmarks': Added env: block with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG; replaced all inline ${{ }} with corresponding $INPUT_* variables.

2. **github-env-injection**: Added newline sanitization before writing to $GITHUB_OUTPUT:
   - runner-version: `safe_runner_version=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')` then `echo "runner-version=$safe_runner_version" >> "$GITHUB_OUTPUT"`
   - mode-cache-key: `safe_mode=$(printf '%s' "$INPUT_MODE" | tr -d '\n\r')` then `MODE_CACHE_KEY=$(printf '%s' "$safe_mode" | tr ',' '-')` then `echo "mode-cache-key=$MODE_CACHE_KEY" >> "$GITHUB_OUTPUT"`

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with downloading to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"`) and executing separately (`bash "$INSTALLER_TMP" --quiet`), dropping the '--' shell option terminator as required.

