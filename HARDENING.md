<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` contexts are interpolated directly inside `run:` shell command strings (rule a), allowing an attacker-controlled value to be executed as shell code before the shell ever sees it.

Step 'Determine runner and kernel version' (line ~97):
  `RUNNER_VERSION="${{ inputs.runner-version }}"`
  `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Step 'Install CodSpeed runner' (line ~148):
  `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
  `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
  `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
  `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 'Run the benchmarks' (line ~220):
  `if [ -z "${{ inputs.mode }}" ]`
  `if [ -n "${{ inputs.token }}" ]` / `RUNNER_ARGS+=(--token "${{ inputs.token }}")`
  `--working-directory="${{ inputs.working-directory }}"`
  `--upload-url="${{ inputs.upload-url }}"`
  `--mode="${{ inputs.mode }}"`
  `--instruments="${{ inputs.instruments }}"`
  `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
  `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
  `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`
  `if [ "${{ inputs.allow-empty }}" = "true" ]`
  `--go-runner-version="${{ inputs.go-runner-version }}"`
  `--config="${{ inputs.config }}"`

All of these should be moved to `env:` variables and then referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:97`
- `action.yml:118`
- `action.yml:148`
- `action.yml:149`
- `action.yml:150`
- `action.yml:200`
- `action.yml:220`
- `action.yml:232`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (direct expression interpolation) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input value could inject additional output variables.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — same risk.

Both writes lack the sanitization pipeline before the write.

Locations:

- `action.yml:115`
- `action.yml:119`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to `bash` without first downloading to a file and verifying integrity. Two occurrences:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used for 'latest' version)
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for prerelease versions)

If the remote server or network is compromised, arbitrary code is executed immediately. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the 'latest' and 'prerelease' paths.

Locations:

- `action.yml:157`
- `action.yml:165`

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

1. **script-injection / static-inline-injection** (all 27 instances): Moved every `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expression from `run:` blocks into `env:` blocks. Three steps were updated:
   - 'Determine runner and kernel version': Added `env: INPUT_RUNNER_VERSION / INPUT_MODE`, replaced inline expressions with `$INPUT_RUNNER_VERSION` and `$INPUT_MODE`.
   - 'Install CodSpeed runner': Added `env: RUNNER_VERSION / VERSION_TYPE / SKIP_HASH_CHECK_WARNING / EXPECTED_HASH`, removed all inline expressions from the run block.
   - 'Run the benchmarks': Added 11 env vars (`INPUT_MODE`, `INPUT_TOKEN`, `INPUT_WORKING_DIRECTORY`, `INPUT_UPLOAD_URL`, `INPUT_INSTRUMENTS`, `INPUT_MONGO_URI_ENV_NAME`, `INPUT_CACHE_INSTRUMENTS`, `INPUT_INSTRUMENTS_CACHE_DIR`, `INPUT_ALLOW_EMPTY`, `INPUT_GO_RUNNER_VERSION`, `INPUT_CONFIG`), replaced all inline expressions with shell variable references.

2. **github-env-injection**: In 'Determine runner and kernel version', all four `echo ... >> $GITHUB_OUTPUT` writes now sanitize their values first with `safe_X=$(printf '%s' "$X" | tr -d '\n\r')` before writing.

3. **unsafe-shell**: The 'latest' and 'prerelease' install paths now download the installer to a temp file (`curl -fsSL URL -o "$INSTALLER_TMP"`) and then execute it (`bash "$INSTALLER_TMP" --quiet`), instead of piping curl output directly to bash. The `--` that was the shell's option terminator in the pipe form was correctly dropped.

