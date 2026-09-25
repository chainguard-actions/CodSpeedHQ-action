<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 34 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version': Multiple ${{ }} expressions are interpolated directly inside the run: shell script — violating rule (a). Offending lines include:
  - `RUNNER_VERSION="${{ inputs.runner-version }}"`
  - `DISTRO="${{ runner.os }}"`
  - `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`
An attacker-controlled value in inputs.runner-version or inputs.mode is expanded by the YAML template engine before the shell ever sees it, enabling shell metacharacter injection.

Locations:

- `action.yml:120`
- `action.yml:140`
- `action.yml:144`

### script-injection (severity: high)

Step 'Install CodSpeed runner': Multiple ${{ }} expressions are interpolated directly inside the run: shell script — violating rule (a). Offending lines include:
  - `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
  - `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
  - `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
  - `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`
These values are substituted by the YAML template engine before the shell parses the script, allowing shell metacharacter injection from workflow-controllable contexts.

Locations:

- `action.yml:175`
- `action.yml:176`
- `action.yml:178`
- `action.yml:207`

### script-injection (severity: high)

Step 'Run the benchmarks': Numerous ${{ inputs.* }} expressions are interpolated directly inside the run: shell script — violating rule (a). Offending lines include:
  - `if [ -z "${{ inputs.mode }}" ]`
  - `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")`
  - `if [ -n "${{ inputs.working-directory }}" ]; then RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
  - `if [ -n "${{ inputs.upload-url }}" ]; then RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
  - `if [ -n "${{ inputs.mode }}" ]; then RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
  - `if [ -n "${{ inputs.instruments }}" ]; then RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
  - `if [ -n "${{ inputs.mongo-uri-env-name }}" ]; then RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
  - `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
  - `if [ "${{ inputs.allow-empty }}" = "true" ]`
  - `if [ -n "${{ inputs.go-runner-version }}" ]; then RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
  - `if [ -n "${{ inputs.config }}" ]; then RUNNER_ARGS+=(--config="${{ inputs.config }}")`
  - `if [ -n "${{ inputs.cycle-estimation }}" ]; then RUNNER_ARGS+=(--cycle-estimation="${{ inputs.cycle-estimation }}")`
  - `if [ -n "${{ inputs.exclude-allocations }}" ]; then RUNNER_ARGS+=(--exclude-allocations="${{ inputs.exclude-allocations }}")`
  - `if [ "${{ inputs.simulation-track-subprocess }}" = "true" ]`
All of these are substituted by the YAML template engine before the shell parses the script, enabling shell metacharacter injection from any caller-supplied input.

Locations:

- `action.yml:232`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`
- `action.yml:256`
- `action.yml:259`
- `action.yml:262`
- `action.yml:265`
- `action.yml:268`
- `action.yml:271`
- `action.yml:274`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version': Two untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):
  1. `inputs.runner-version` is read into $RUNNER_VERSION (via `RUNNER_VERSION="${{ inputs.runner-version }}"`), then written with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline in the input can inject arbitrary key=value pairs into GITHUB_OUTPUT.
  2. `inputs.mode` is read into $MODE_CACHE_KEY (via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`), then written with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` only strips commas, not newlines, so a newline in inputs.mode still injects into GITHUB_OUTPUT.

Locations:

- `action.yml:120`
- `action.yml:144`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner': Remote install scripts are fetched and piped directly to bash without first saving to a file and verifying integrity. Two occurrences:
  1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used for 'latest' version)
  2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for 'prerelease' version)
Note: the 'release' code path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths bypass this protection entirely.

Locations:

- `action.yml:188`
- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:116`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:296`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection (Determine runner and kernel version)**: Added env: block with INPUT_RUNNER_VERSION, RUNNER_OS, INPUT_MODE. Replaced all ${{ }} inline expressions in the run: block with plain $VAR references.

2. **github-env-injection (Determine runner and kernel version)**: Added `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` sanitization before writing runner-version to GITHUB_OUTPUT. Added `printf '%s' "$INPUT_MODE" | tr -d '\n\r'` sanitization before computing mode-cache-key and writing to GITHUB_OUTPUT.

3. **script-injection / static-inline-injection (Install CodSpeed runner)**: Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH. Removed all inline ${{ }} expressions from the run: block.

4. **unsafe-shell (Install CodSpeed runner)**: Fixed both `curl ... | bash -s -- --quiet` patterns for 'latest' and 'prerelease' paths. Now downloads to a temp file with `curl -fsSL URL -o "$INSTALLER_TMP"` then executes `bash "$INSTALLER_TMP" --quiet` (dropped the `--` as it was the shell's option terminator, not the script's argument).

5. **script-injection / static-inline-injection (Run the benchmarks)**: Added env: block with all 15 input variables (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG, INPUT_CYCLE_ESTIMATION, INPUT_EXCLUDE_ALLOCATIONS, INPUT_SIMULATION_TRACK_SUBPROCESS). Replaced all inline ${{ inputs.* }} references with plain $INPUT_* env var references.

