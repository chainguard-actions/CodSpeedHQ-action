<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ }} expressions are interpolated directly inside run: shell command strings in the 'Determine runner and kernel version' step. Offending lines include:
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input injected directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input injected directly into shell
These values are YAML-template-substituted before the shell ever sees them, allowing shell metacharacter injection.

Locations:

- `action.yml:96`
- `action.yml:117`

### script-injection (severity: high)

Rule (a): Multiple ${{ }} expressions are interpolated directly inside the run: shell command string in the 'Install CodSpeed runner' step. Offending lines include:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`
All of these are YAML-interpolated before the shell processes them, enabling shell metacharacter injection.

Locations:

- `action.yml:138`
- `action.yml:139`
- `action.yml:141`
- `action.yml:175`

### script-injection (severity: high)

Rule (a): Numerous ${{ inputs.* }} expressions are interpolated directly inside the run: shell command string in the 'Run the benchmarks' step. Offending lines include:
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")`
All inputs are attacker-controllable and are YAML-substituted before the shell processes them.

Locations:

- `action.yml:160`
- `action.yml:165`
- `action.yml:168`
- `action.yml:171`
- `action.yml:174`
- `action.yml:177`
- `action.yml:180`
- `action.yml:183`
- `action.yml:186`
- `action.yml:189`
- `action.yml:192`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' run: block writes values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r'):
1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — RUNNER_VERSION is set from `${{ inputs.runner-version }}` earlier in the same script and then manipulated, but never sanitized before the write.
2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — MODE_CACHE_KEY is derived from `${{ inputs.mode }}` (via `echo "${{ inputs.mode }}" | tr ',' '-'`); the tr only removes commas, not newlines, so newline injection into GITHUB_OUTPUT is still possible.
An attacker can inject newlines into these values to poison subsequent steps that read these outputs.

Locations:

- `action.yml:115`
- `action.yml:119`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes a remotely-fetched script directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This is executed when VERSION_TYPE is 'latest'. If the remote server is compromised or the URL is redirected, arbitrary code will execute on the runner immediately.

Locations:

- `action.yml:149`

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

Fixed all findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH; removed inline ${{ steps.installer-hash.outputs.hash }} from run: block
   - 'Run the benchmarks': Added env: block with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG; updated all shell references to use env vars

2. github-env-injection: Added sanitization before writing to $GITHUB_OUTPUT in 'Determine runner and kernel version':
   - runner-version: sanitized with printf '%s' | tr -d '\n\r'
   - mode-cache-key: sanitized with printf '%s' | tr ',' '-' | tr -d '\n\r'

3. unsafe-shell: Replaced 'curl ... | bash -s -- --quiet' with download-then-execute pattern: curl downloads to a temp file, then bash executes the file directly with '--quiet' (dropped the '--' shell option terminator as it was not the script's argument).

