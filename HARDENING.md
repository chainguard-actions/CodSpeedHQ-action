<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions are directly interpolated inside run: shell command strings in action.yml, violating sub-rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

Affected lines in the 'Determine runner and kernel version' step:
  - `RUNNER_VERSION="${{ inputs.runner-version }}"`
  - `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Affected lines in the 'Install CodSpeed runner' step:
  - `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
  - `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
  - `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`

Affected lines in the 'Run the benchmarks' step (many occurrences):
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

All ${{ ... }} expressions must be moved to env: blocks and the env vars must be double-quoted in the shell script.

Locations:

- `action.yml:93`
- `action.yml:120`
- `action.yml:135`
- `action.yml:136`
- `action.yml:138`
- `action.yml:175`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled input) and then written directly: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which only replaces commas, not newlines) and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` step does not strip newline characters, so a newline in `inputs.mode` can still inject additional entries.

Fix: apply `printf '%s' "$VAR" | tr -d '\n\r'` before each write to $GITHUB_OUTPUT.

Locations:

- `action.yml:113`
- `action.yml:114`
- `action.yml:120`
- `action.yml:121`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths, without downloading to a file first and verifying integrity:

1. Latest version path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
   If the remote server is compromised or the URL is intercepted (MITM), arbitrary code executes on the runner.

2. Prerelease version path: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`
   Same risk, and additionally the URL is constructed from a user-controlled value ($RUNNER_VERSION).

Note: the release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — that path is safe. The 'latest' and 'prerelease' paths should follow the same pattern.

Locations:

- `action.yml:152`
- `action.yml:160`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). All shell references updated to use the env var names.

2. github-env-injection: Applied printf '%s' "$VAR" | tr -d '\n\r' sanitization before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed the 'latest' and 'prerelease' install paths to download the script to a temp file (mktemp) with curl -o, then execute with bash, instead of piping directly. The '--' was dropped since it was the shell's option terminator (not the script's argument), so the script correctly receives '--quiet' as $1.

