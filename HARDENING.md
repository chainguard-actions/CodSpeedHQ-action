<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.2** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote scripts directly to bash without first downloading to a file. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version path, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for the 'prerelease' version path. An attacker who can intercept or tamper with the remote URL can execute arbitrary code on the runner. The release path correctly downloads to a temp file and verifies a hash — the same pattern should be applied to all paths.

Locations:

- `action.yml:163`
- `action.yml:169`

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings across three steps, violating sub-rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 'Determine runner and kernel version':
- `RUNNER_VERSION="${{ inputs.runner-version }}"` (line ~110)
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line ~131)

Step 'Install CodSpeed runner':
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line ~152)
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line ~153)
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line ~155)
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line ~210)

Step 'Run the benchmarks':
- `if [ -z "${{ inputs.mode }}" ]` and `--mode="${{ inputs.mode }}"` (lines ~232, ~244)
- `--token "${{ inputs.token }}"` (line ~237)
- `--working-directory="${{ inputs.working-directory }}"` (line ~240)
- `--upload-url="${{ inputs.upload-url }}"` (line ~243)
- `--instruments="${{ inputs.instruments }}"` (line ~247)
- `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"` (line ~250)
- `${{ inputs.cache-instruments }}` and `${{ inputs.instruments-cache-dir }}` (line ~253)
- `${{ inputs.allow-empty }}` (line ~256)
- `--go-runner-version="${{ inputs.go-runner-version }}"` (line ~259)
- `--config="${{ inputs.config }}"` (line ~262)

All these inputs should be passed via env: variables and referenced as quoted shell variables instead.

Locations:

- `action.yml:110`
- `action.yml:131`
- `action.yml:152`
- `action.yml:153`
- `action.yml:155`
- `action.yml:210`
- `action.yml:232`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`
- `action.yml:256`
- `action.yml:259`
- `action.yml:262`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to $GITHUB_OUTPUT without sanitization:

1. `RUNNER_VERSION` is derived from `${{ inputs.runner-version }}` (an attacker-controlled input) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without applying `printf '%s' ... | tr -d '\n\r'` sanitization first. A newline in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. The `tr ',' '-'` only strips commas, not newlines, so a newline in `inputs.mode` can still inject additional entries into GITHUB_OUTPUT.

Locations:

- `action.yml:128`
- `action.yml:132`

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

**Fixes applied:** unsafe-shell, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. unsafe-shell (2 occurrences): Replaced `curl ... | bash -s -- --quiet` with download-then-execute pattern for both 'latest' and 'prerelease' version paths. Scripts are now downloaded to a temp file via `curl -fsSL <url> -o "$INSTALLER_TMP"` and then executed with `bash "$INSTALLER_TMP" --quiet`. The `--` was correctly dropped as it was the shell's option terminator for `-s`, not a script argument.

2. script-injection / static-inline-injection (26 occurrences): Moved all `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added env: with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH
   - 'Run the benchmarks': Added env: with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG

3. github-env-injection (2 occurrences): Added newline sanitization before writing to GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` for both runner-version and mode-cache-key outputs.

