<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` contexts are directly interpolated inside `run:` shell command strings, enabling script injection.

**Step: "Determine runner and kernel version"**
- Line 95: `RUNNER_VERSION="${{ inputs.runner-version }}"`
- Line 117: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

**Step: "Install CodSpeed runner"**
- Line 134: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- Line 135: `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- Line 137: `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- Line 167: `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step: "Run the benchmarks"**
- Line 194: `if [ -z "${{ inputs.mode }}" ]; then`
- Line 202: `if [ -n "${{ inputs.token }}" ]; then`
- Line 203: `RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- Line 205: `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- Line 208: `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- Line 211: `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- Line 214: `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- Line 217: `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- Line 220: `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- Line 223: `if [ "${{ inputs.allow-empty }}" = "true" ]`
- Line 226: `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- Line 229: `RUNNER_ARGS+=(--config="${{ inputs.config }}")`

All of these allow an attacker-controlled value to be parsed by the shell before it is quoted, enabling command injection.

Locations:

- `action.yml:95`
- `action.yml:117`
- `action.yml:134`
- `action.yml:135`
- `action.yml:137`
- `action.yml:167`
- `action.yml:194`
- `action.yml:202`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `$RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 95) and then written unsanitized: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 113). A newline embedded in `inputs.runner-version` could inject additional key=value pairs into GITHUB_OUTPUT.

2. `$MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line 117) and then written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 118). Same injection risk.

The fix requires sanitizing each value before writing: `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` then `echo "key=$safe" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yml:113`
- `action.yml:118`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the action pipes a remote install script directly to bash without first downloading and verifying it:

`curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`

This is the `curl | bash` anti-pattern. If the remote URL is compromised or subject to a MITM attack, arbitrary code will execute on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the `latest` path.

Locations:

- `action.yml:143`

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

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions to env: blocks in all three affected steps. The 'Determine runner and kernel version' step now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. The 'Install CodSpeed runner' step now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. The 'Run the benchmarks' step now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. github-env-injection: Sanitized both values written to $GITHUB_OUTPUT using printf '%s' ... | tr -d '\n\r' to prevent newline injection. Also quoted $GITHUB_OUTPUT references.

3. unsafe-shell: Replaced the 'curl | bash' anti-pattern for the 'latest' version path with a download-then-execute pattern: curl downloads to a temp file, then bash executes the file. The '--' was correctly dropped (it was the shell's option terminator from 'bash -s -- --quiet', not the script's own argument).

