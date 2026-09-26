<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml.

**Step: 'Determine runner and kernel version'** (line ~104):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input injected directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input injected directly into shell

**Step: 'Install CodSpeed runner'** (line ~160):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step: 'Run the benchmarks'** (line ~213):
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")`

All of these allow an attacker who controls the inputs (e.g. via a calling workflow) to inject arbitrary shell commands.

Locations:

- `action.yml:104`
- `action.yml:138`
- `action.yml:160`
- `action.yml:161`
- `action.yml:163`
- `action.yml:196`
- `action.yml:213`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:246`
- `action.yml:249`

### github-env-injection (severity: high)

Untrusted input values derived from `inputs.*` are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

**Step: 'Determine runner and kernel version'**:
- `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~104) and then written unsanitized: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~134). An attacker can inject newlines to poison subsequent GITHUB_OUTPUT entries.
- `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line ~138) and written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~139). The `tr ',' '-'` only strips commas, not newlines/carriage-returns.

Neither write is preceded by `printf '%s' ... | tr -d '\n\r'` sanitization.

Locations:

- `action.yml:134`
- `action.yml:139`

### unsafe-shell (severity: high)

Two `run:` blocks in the 'Install CodSpeed runner' step pipe remote content fetched via `curl` directly to `bash` without first saving to a file and verifying integrity:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used for the 'latest' version path. The script is fetched and executed in one pipeline with no hash verification.

2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used for the 'prerelease' version path. Similarly, no hash verification before execution.

If the remote server or network is compromised, arbitrary code can be executed on the runner. (Note: the 'release' version path correctly downloads to a temp file and verifies the SHA-256 hash before executing.)

Locations:

- `action.yml:170`
- `action.yml:177`

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

1. **script-injection / static-inline-injection** (all locations): Moved all `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions from `run:` shell blocks into `env:` blocks. Three steps were affected:
   - 'Determine runner and kernel version': Added `env: INPUT_RUNNER_VERSION / INPUT_MODE` and updated shell to use `$INPUT_RUNNER_VERSION` / `$INPUT_MODE`.
   - 'Install CodSpeed runner': Added `env: RUNNER_VERSION / VERSION_TYPE / SKIP_HASH_CHECK_WARNING / EXPECTED_HASH` and removed inline expressions from the run block.
   - 'Run the benchmarks': Added `env:` entries for all 11 inputs (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG) and updated all shell references.

2. **github-env-injection**: Sanitized all values written to `$GITHUB_OUTPUT` in the 'Determine runner and kernel version' step using `printf '%s' "$VAR" | tr -d '\n\r'` before writing. Also fixed `MODE_CACHE_KEY` to use `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'` (chained sanitization).

3. **unsafe-shell**: Fixed two `curl | bash -s -- --quiet` patterns in the 'Install CodSpeed runner' step (for 'latest' and 'prerelease' paths). Both now download to a temp file first with `curl -fsSL <url> -o "$INSTALLER_TMP"` and then execute with `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped as it was the shell's option terminator, not the script's argument.

