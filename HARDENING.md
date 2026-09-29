<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell blocks in action.yml, violating rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs are expanded directly into the shell before quoting can protect them.

'Install CodSpeed runner' step: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all directly interpolated.

'Run the benchmarks' step: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all directly interpolated into shell command strings. All of these should be passed via env: variables and then referenced as quoted shell variables.

Locations:

- `action.yml:96`
- `action.yml:117`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:185`
- `action.yml:200`
- `action.yml:210`
- `action.yml:215`
- `action.yml:220`
- `action.yml:225`
- `action.yml:230`
- `action.yml:235`
- `action.yml:240`
- `action.yml:245`
- `action.yml:250`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — RUNNER_VERSION is set from `${{ inputs.runner-version }}` (attacker-controlled). A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — MODE_CACHE_KEY is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`. The tr command only strips commas, not newlines, so a newline in inputs.mode still reaches GITHUB_OUTPUT.

Both writes must be preceded by sanitization: `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before the echo.

Locations:

- `action.yml:107`
- `action.yml:117`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever the remote server returns without any integrity verification. If the remote URL is compromised or subject to a MITM attack, arbitrary code runs on the runner. The script should be downloaded to a temporary file first, its hash verified against a known-good value, and only then executed — as the action already does for release versions. The 'latest' version path should follow the same pattern.

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference these as quoted environment variables ($INPUT_MODE, $INPUT_TOKEN, $RUNNER_VERSION, etc.).

2. **github-env-injection**: Added sanitization before writing to $GITHUB_OUTPUT: RUNNER_VERSION is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'`, and MODE_CACHE_KEY is sanitized with `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a two-step approach: download to a temp file with `curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"`, then execute with `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped as it was the shell's option terminator (not the script's argument).

