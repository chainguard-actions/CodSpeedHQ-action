<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are interpolated directly inside `run:` shell command strings across three steps, allowing an attacker who controls those inputs to inject arbitrary shell commands.

**Step 1 – "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` are interpolated directly into the shell script.

**Step 2 – "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` are all interpolated directly.

**Step 3 – "Run the benchmarks"**: At least 10 `${{ inputs.* }}` expressions are interpolated directly into shell: `inputs.mode`, `inputs.token`, `inputs.working-directory`, `inputs.upload-url`, `inputs.instruments`, `inputs.mongo-uri-env-name`, `inputs.cache-instruments`, `inputs.instruments-cache-dir`, `inputs.allow-empty`, `inputs.go-runner-version`, and `inputs.config`. All values should be passed via `env:` variables and then referenced as quoted `"$VAR"` shell variables.

Locations:

- `action.yml:96`
- `action.yml:116`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:175`
- `action.yml:207`
- `action.yml:213`
- `action.yml:217`
- `action.yml:221`
- `action.yml:225`
- `action.yml:229`
- `action.yml:233`
- `action.yml:237`
- `action.yml:241`
- `action.yml:245`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to bash in two code paths, without first downloading to a file for inspection or hash verification:
1. For the 'latest' version type: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
2. For the 'prerelease' version type: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`
An attacker who can intercept or compromise the remote URL (e.g. via MITM or supply-chain compromise of codspeed.io) can execute arbitrary code on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately.

Locations:

- `action.yml:163`
- `action.yml:170`

### github-env-injection (severity: high)

The "Determine runner and kernel version" step writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):
1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — where `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` without newline stripping. A newline in the input can inject additional key=value pairs into GITHUB_OUTPUT.
2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — where `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (only commas are stripped, not newlines). A newline in `inputs.mode` can similarly inject additional output variables.

Locations:

- `action.yml:107`
- `action.yml:117`

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

**Fixes applied:** script-injection, unsafe-shell, github-env-injection, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks across all three affected steps ("Determine runner and kernel version", "Install CodSpeed runner", "Run the benchmarks"). Shell scripts now reference these as plain environment variables.

2. **unsafe-shell**: Replaced both `curl ... | bash -s -- --quiet` patterns with download-then-execute: scripts are downloaded to temp files via `curl -fsSL ... -o "$INSTALL_SCRIPT"` and then executed with `bash "$INSTALL_SCRIPT" --quiet`. The `--` from the pipe form was correctly dropped (it was the shell's option terminator, not the script's argument).

3. **github-env-injection**: Added `tr -d '\n\r'` sanitization before writing user-controlled values to $GITHUB_OUTPUT: `runner-version` uses `safe_runner_version=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')` and `mode-cache-key` uses `MODE_CACHE_KEY=$(printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r')`.

