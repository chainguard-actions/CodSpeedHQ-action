<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` contexts are directly interpolated inside `run:` shell command strings in action.yml. This is a script injection vulnerability: the YAML template substitution occurs before the shell parses the command, so an attacker-controlled value (e.g. a malicious `inputs.runner-version`, `inputs.mode`, `inputs.token`, etc.) can inject arbitrary shell commands.

Violating lines in the 'Determine runner and kernel version' step (sub-rule a):
- `RUNNER_VERSION="${{ inputs.runner-version }}"`
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Violating lines in the 'Install CodSpeed runner' step (sub-rule a):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Violating lines in the 'Run the benchmarks' step (sub-rule a):
- `if [ -z "${{ inputs.mode }}" ]; then`
- `if [ -n "${{ inputs.token }}" ]; then` / `RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `if [ -n "${{ inputs.working-directory }}" ]; then` / `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- `if [ -n "${{ inputs.upload-url }}" ]; then` / `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- `if [ -n "${{ inputs.mode }}" ]; then` / `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- `if [ -n "${{ inputs.instruments }}" ]; then` / `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- `if [ -n "${{ inputs.mongo-uri-env-name }}" ]; then` / `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `if [ -n "${{ inputs.go-runner-version }}" ]; then` / `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- `if [ -n "${{ inputs.config }}" ]; then` / `RUNNER_ARGS+=(--config="${{ inputs.config }}")`

All inputs should be passed via `env:` variables and referenced as quoted shell variables (e.g. `"$INPUT_MODE"`) instead of being interpolated directly.

Locations:

- `action.yml:103`
- `action.yml:118`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:185`
- `action.yml:215`
- `action.yml:221`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` is assigned to the shell variable `$RUNNER_VERSION`, which is then written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline character in the input value could inject additional key=value pairs into `$GITHUB_OUTPUT`, poisoning subsequent steps.

Similarly, `${{ inputs.mode }}` flows into `$MODE_CACHE_KEY` (via `echo "${{ inputs.mode }}" | tr ',' '-'`) and is then written to `$GITHUB_OUTPUT` without sanitization.

Affected writes:
- `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (RUNNER_VERSION sourced from `${{ inputs.runner-version }}`)
- `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` (VERSION_TYPE derived from RUNNER_VERSION)
- `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (MODE_CACHE_KEY sourced from `${{ inputs.mode }}`)

Fix: sanitize before writing, e.g. `safe=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'); echo "runner-version=$safe" >> "$GITHUB_OUTPUT"`

Locations:

- `action.yml:115`
- `action.yml:116`
- `action.yml:119`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote shell scripts directly to `bash` without first downloading them to a file for inspection or hash verification. This pattern is used for the 'latest' and 'prerelease' version types:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (latest version path)
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (prerelease version path)

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately — as is already done for the release version path in the same step.

Locations:

- `action.yml:157`
- `action.yml:163`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added INPUT_RUNNER_VERSION and INPUT_MODE env vars
   - 'Install CodSpeed runner': Added RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH env vars
   - 'Run the benchmarks': Added INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG env vars

2. github-env-injection: Sanitized RUNNER_VERSION, VERSION_TYPE, and MODE_CACHE_KEY before writing to $GITHUB_OUTPUT using printf '%s' | tr -d '\n\r'.

3. unsafe-shell: Fixed 'latest' and 'prerelease' install paths to download scripts to temp files (mktemp) then execute separately, instead of piping curl | bash. Dropped the '--' shell option terminator as instructed (it was the shell's, not the script's).

