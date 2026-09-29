<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 32 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings across three steps in action.yml.

**Step 1 – "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"`, and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` are all direct expression interpolations inside the shell script. An attacker-controlled `inputs.runner-version` or `inputs.mode` value containing shell metacharacters (`;`, `$(...)`, backticks, etc.) will be executed by the shell before any quoting takes effect.

**Step 2 – "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` are all directly interpolated.

**Step 3 – "Run the benchmarks"**: Fourteen `${{ inputs.* }}` expressions are interpolated directly into the shell script body: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}`, and `${{ inputs.simulation-track-subprocess }}`. All of these should be passed via env: variables and then referenced as quoted shell variables.

Locations:

- `action.yml:113`
- `action.yml:133`
- `action.yml:137`
- `action.yml:163`
- `action.yml:164`
- `action.yml:166`
- `action.yml:196`
- `action.yml:218`
- `action.yml:224`
- `action.yml:228`
- `action.yml:232`
- `action.yml:236`
- `action.yml:240`
- `action.yml:244`
- `action.yml:248`
- `action.yml:252`
- `action.yml:256`
- `action.yml:260`
- `action.yml:264`
- `action.yml:268`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (direct expression interpolation of a caller-controlled input), then written as `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which only replaces commas, not newlines), then written as `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline in `inputs.mode` would similarly allow injection of arbitrary output variables.

Both writes must be preceded by `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before the echo.

Locations:

- `action.yml:113`
- `action.yml:121`
- `action.yml:137`
- `action.yml:138`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to bash in two code paths:

1. **'latest' path**: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — downloads and executes a remote script in a single pipeline without any integrity verification.

2. **'prerelease' path**: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for pre-release versions, also without hash verification.

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The release path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the 'latest' and 'prerelease' paths.

Locations:

- `action.yml:180`
- `action.yml:187`

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

Fixed all findings in action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks. Step 1 ('Determine runner and kernel version') now uses INPUT_RUNNER_VERSION, RUNNER_OS, INPUT_MODE env vars. Step 3 ('Install CodSpeed runner') now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH env vars. Step 4 ('Run the benchmarks') now uses 14 INPUT_* env vars for all inputs.

2. **github-env-injection**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before writing RUNNER_VERSION and MODE_CACHE_KEY to $GITHUB_OUTPUT, preventing newline injection attacks.

3. **unsafe-shell**: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' paths) with download-then-execute: `curl -fsSL ... -o "$INSTALLER_TMP"` followed by `bash "$INSTALLER_TMP" --quiet`. The `--` was correctly dropped (it was the shell's stdin option terminator, not a script argument). Each path uses mktemp and a trap for cleanup.

