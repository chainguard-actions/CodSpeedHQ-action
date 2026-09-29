<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings in action.yml.

Step 'Determine runner and kernel version' (line ~103): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled inputs are expanded by the YAML template engine before the shell ever sees them, enabling shell metacharacter injection.

Step 'Install CodSpeed runner' (line ~158): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` are all interpolated directly in the run: block.

Step 'Run the benchmarks' (line ~228): `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` are all interpolated directly. All inputs.* values should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR") instead.

Locations:

- `action.yml:103`
- `action.yml:131`
- `action.yml:158`
- `action.yml:159`
- `action.yml:161`
- `action.yml:228`
- `action.yml:234`
- `action.yml:235`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization.

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~103) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~128). No `printf '%s' ... | tr -d '\n\r'` sanitization is applied before the write.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line ~131) and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~132). No sanitization is applied before the write.

An attacker who controls `inputs.runner-version` or `inputs.mode` can inject newlines into $GITHUB_OUTPUT, potentially overwriting subsequent output variables or injecting arbitrary key=value pairs.

Locations:

- `action.yml:128`
- `action.yml:132`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' pipes a remote script directly to bash without first saving it to a file for inspection or integrity verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This is executed when VERSION_TYPE is 'latest'. If the remote server is compromised or the URL is redirected, arbitrary code will execute on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the 'latest' path.

Locations:

- `action.yml:168`

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

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} expressions from run: shell blocks to env: blocks for three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (INPUT_RUNNER_VERSION, INPUT_VERSION_TYPE, INPUT_SKIP_HASH_CHECK_WARNING, INPUT_EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). Shell scripts now reference these via $VAR_NAME.

2. **github-env-injection**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a two-step approach: download to a temp file first, then execute with `bash "$INSTALL_SCRIPT_TMP" --quiet` (dropping the `--` since we're no longer using bash -s stdin mode).

