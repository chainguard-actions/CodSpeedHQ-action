<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version' directly interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} inside the run: shell script (sub-rule a). These are untrusted inputs that flow through YAML template substitution before the shell sees them, enabling command injection. Offending lines:
  Line 97:  RUNNER_VERSION="${{ inputs.runner-version }}"
  Line 128: MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')

Locations:

- `action.yml:97`
- `action.yml:128`

### script-injection (severity: high)

Step 'Install CodSpeed runner' directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} inside the run: shell script (sub-rule a). These expressions are substituted before the shell parses the script, enabling injection. Offending lines:
  Line 154: RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
  Line 155: VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
  Line 157: SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
  Line ~186: EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"

Locations:

- `action.yml:154`
- `action.yml:155`
- `action.yml:157`
- `action.yml:186`

### script-injection (severity: high)

Step 'Run the benchmarks' directly interpolates numerous ${{ inputs.* }} expressions inside the run: shell script (sub-rule a). Every inputs.* value is substituted into the shell before execution, allowing an attacker-controlled input to inject arbitrary shell commands. Offending lines include:
  if [ -z "${{ inputs.mode }}" ]
  RUNNER_ARGS+=(--token "${{ inputs.token }}")
  RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")
  RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")
  RUNNER_ARGS+=(--mode="${{ inputs.mode }}")
  RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")
  RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")
  if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]
  RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")
  if [ "${{ inputs.allow-empty }}" = "true" ]
  RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")
  RUNNER_ARGS+=(--config="${{ inputs.config }}")

Locations:

- `action.yml:210`
- `action.yml:214`
- `action.yml:217`
- `action.yml:220`
- `action.yml:223`
- `action.yml:226`
- `action.yml:229`
- `action.yml:232`
- `action.yml:235`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization (printf '%s' ... | tr -d '\n\r'). The variable RUNNER_VERSION is set from ${{ inputs.runner-version }} (line 97) and then written to $GITHUB_OUTPUT at line 120 without sanitization. Similarly, MODE_CACHE_KEY is derived from ${{ inputs.mode }} (line 128) and written to $GITHUB_OUTPUT at line 129 without sanitization. A newline-containing input value could inject arbitrary key=value pairs into the output context.

Locations:

- `action.yml:120`
- `action.yml:129`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' pipes remote content directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever script the remote server returns without any integrity verification at the point of execution. A compromised or MITM'd server could deliver malicious code. The script should be downloaded to a file first, verified (e.g. hash check), and then executed separately.

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks for all three affected steps:
   - 'Determine runner and kernel version': Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH
   - 'Run the benchmarks': Added env: block with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG

2. **github-env-injection**: Added sanitization using `printf '%s' "$VAR" | tr -d '\n\r'` before writing RUNNER_VERSION, VERSION_TYPE, KERNEL_VERSION, and MODE_CACHE_KEY to $GITHUB_OUTPUT.

3. **unsafe-shell**: Fixed the `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` pattern in the 'latest' version path by downloading the script to a temp file first (`curl -fsSL ... -o "$INSTALL_SCRIPT"`), then executing it separately (`bash "$INSTALL_SCRIPT" --quiet`). The `--` was dropped as it was the shell's option terminator, not the script's argument.

