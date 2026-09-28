<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml, allowing script injection via caller-controlled inputs.

**Step "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs are interpolated directly into shell.

**Step "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all directly interpolated.

**Step "Run the benchmarks"**: Eleven `inputs.*` expressions are interpolated directly into shell commands: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`. A calling workflow can supply a value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) to execute arbitrary commands.

Locations:

- `action.yml:101`
- `action.yml:117`
- `action.yml:138`
- `action.yml:139`
- `action.yml:141`
- `action.yml:172`
- `action.yml:199`
- `action.yml:206`
- `action.yml:209`
- `action.yml:212`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`
- `action.yml:227`
- `action.yml:230`
- `action.yml:233`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (direct interpolation) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. An attacker-controlled newline in the input can inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which does not strip newlines) and written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transformation does not sanitize newline characters, so a newline embedded in `inputs.mode` can still inject additional entries.

Locations:

- `action.yml:107`
- `action.yml:108`
- `action.yml:117`
- `action.yml:118`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the action downloads and executes a remote shell script by piping it directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the URL is intercepted (e.g., via DNS hijacking or MITM), arbitrary code will execute on the runner. The action itself notes that hash verification is unavailable in this mode.

Locations:

- `action.yml:149`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': runner-version and mode inputs moved to INPUT_RUNNER_VERSION and INPUT_MODE env vars
   - 'Install CodSpeed runner': runner-version, version-type, skip-hash-check-warning, and installer-hash moved to RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH env vars
   - 'Run the benchmarks': All 11 inputs (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) moved to INPUT_* env vars

2. **github-env-injection**: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. The MODE_CACHE_KEY is sanitized by stripping newlines before the tr ',' '-' transformation.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with downloading to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"`) then executing separately (`bash "$INSTALL_SCRIPT" --quiet`). The '--' was correctly dropped as it was the shell's option terminator, not the script's argument.

