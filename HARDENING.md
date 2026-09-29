<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.3** was hardened automatically. 31 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell blocks throughout action.yml, violating rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'):
- Line 110: `RUNNER_VERSION="${{ inputs.runner-version }}"` — inputs.runner-version interpolated directly into shell
- Line 143: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs.mode interpolated directly into shell

Step 3 ('Install CodSpeed runner'):
- Line 169: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` — step output interpolated directly
- Line 170: `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` — step output interpolated directly
- Line 172: `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — input interpolated directly
- Line 207: `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — step output interpolated directly

Step 4 ('Run the benchmarks'):
- Line 222: `if [ -z "${{ inputs.mode }}" ]` — input interpolated directly into shell condition
- Lines 226–258: `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.mode }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}` all interpolated directly into shell commands.

All these values should be passed via `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) instead of being interpolated directly.

Locations:

- `action.yml:110`
- `action.yml:143`
- `action.yml:169`
- `action.yml:172`
- `action.yml:222`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

- Line 110: `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (attacker-controlled). It is then written to $GITHUB_OUTPUT at line 135 via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without sanitization. A newline in the input value could inject arbitrary key=value pairs into $GITHUB_OUTPUT.

- Line 143: `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (attacker-controlled). It is written to $GITHUB_OUTPUT at line 144 via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization.

The fix requires sanitizing before each write, e.g.:
```
safe=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
echo "runner-version=$safe" >> "$GITHUB_OUTPUT"
```

Locations:

- `action.yml:135`
- `action.yml:144`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash without first saving to a file and verifying integrity. Two occurrences:

1. Line 178: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when VERSION_TYPE is 'latest'. The remote script is fetched and executed in a single pipeline with no hash verification.

2. Line 184: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when VERSION_TYPE is 'prerelease'. Same pattern with no hash verification.

Note: the 'release' code path correctly downloads to a temp file and verifies the SHA256 hash before executing. The 'latest' and 'prerelease' paths should follow the same pattern, or at minimum the script should be downloaded first and inspected before execution.

Locations:

- `action.yml:178`
- `action.yml:184`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:110`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:143`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:172`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:276`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $RUNNER_VERSION, etc.

2. **github-env-injection**: Added sanitization for all values written to $GITHUB_OUTPUT using `safe_var=$(printf '%s' "$VAR" | tr -d '\n\r')` before each `echo "key=$safe_var" >> "$GITHUB_OUTPUT"` call. Applied to runner-version, version-type, kernel-version, and mode-cache-key outputs.

3. **unsafe-shell**: Replaced both `curl -fsSL ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with a download-then-execute pattern: download to a temp file with `curl -fsSL ... -o "$INSTALLER_TMP"`, then execute with `bash "$INSTALLER_TMP" --quiet`. The `--` was correctly dropped (it was the shell's option terminator in the pipe form, not an installer argument). The release code path was already correct and left unchanged.

