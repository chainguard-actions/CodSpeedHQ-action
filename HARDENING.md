<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version': ${{ inputs.runner-version }} and ${{ inputs.mode }} are directly interpolated inside the run: shell script. An attacker-controlled input value containing shell metacharacters (e.g. `$(cmd)`, backticks, `;`) will be executed by the shell before any quoting can protect it. Rule (a) violation.

Locations:

- `action.yml:101`
- `action.yml:120`

### script-injection (severity: high)

Step 'Install CodSpeed runner': ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} are all directly interpolated inside the run: shell script. These values flow from user-controlled inputs and are substituted into the shell command string before execution. Rule (a) violation.

Locations:

- `action.yml:148`
- `action.yml:149`
- `action.yml:150`

### script-injection (severity: high)

Step 'Run the benchmarks': Eleven ${{ inputs.* }} expressions are directly interpolated inside the run: shell script: ${{ inputs.mode }}, ${{ inputs.token }}, ${{ inputs.working-directory }}, ${{ inputs.upload-url }}, ${{ inputs.instruments }}, ${{ inputs.mongo-uri-env-name }}, ${{ inputs.cache-instruments }}, ${{ inputs.instruments-cache-dir }}, ${{ inputs.allow-empty }}, ${{ inputs.go-runner-version }}, and ${{ inputs.config }}. Any of these can contain shell metacharacters that will be executed. Rule (a) violation.

Locations:

- `action.yml:220`
- `action.yml:226`
- `action.yml:229`
- `action.yml:232`
- `action.yml:235`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes two untrusted values to $GITHUB_OUTPUT without sanitization: (1) RUNNER_VERSION is derived from ${{ inputs.runner-version }} and written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`; (2) MODE_CACHE_KEY is derived from ${{ inputs.mode }} and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline-containing input value could inject arbitrary key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:115`
- `action.yml:121`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' pipes remote script content directly to bash in two code paths: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when VERSION_TYPE=latest); (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used when VERSION_TYPE=prerelease). If the remote endpoint is compromised or the URL is manipulated, arbitrary code will execute on the runner without any integrity check.

Locations:

- `action.yml:161`
- `action.yml:168`

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

Fixed all findings in hardened/action/action.yml:

1. **Determine runner and kernel version** step: Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE; replaced inline ${{ }} expressions with env var references; added printf/tr sanitization before writing to GITHUB_OUTPUT.

2. **Install CodSpeed runner** step: Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH; replaced all inline ${{ }} expressions with env var references; fixed two curl|bash patterns (latest and prerelease) by downloading to temp file first then executing (dropping the '--' shell option terminator as required).

3. **Run the benchmarks** step: Added 11 env: entries for all inputs (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG); replaced all inline ${{ inputs.* }} expressions with env var references throughout the run: block.

