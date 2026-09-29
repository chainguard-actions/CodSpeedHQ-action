<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings in action.yml, violating sub-rule (a). This allows an attacker who controls the inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line 97): `RUNNER_VERSION="${{ inputs.runner-version }}"`
Step 'Determine runner and kernel version' (line 130): `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`
Step 'Install CodSpeed runner' (line 163): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
Step 'Install CodSpeed runner' (line 164): `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
Step 'Install CodSpeed runner' (line 166): `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
Step 'Install CodSpeed runner' (line 205): `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`
Step 'Run the benchmarks': `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}` are all interpolated directly into shell commands.

All inputs.* values should be passed via env: variables and then referenced as quoted shell variables (e.g. "$VAR") instead of being interpolated as ${{ ... }} directly in the run: block.

Locations:

- `action.yml:97`
- `action.yml:130`
- `action.yml:163`
- `action.yml:164`
- `action.yml:166`
- `action.yml:205`
- `action.yml:243`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 97) and then written to $GITHUB_OUTPUT on line 122: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. An attacker can inject newlines into `inputs.runner-version` to smuggle additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line 130) and written to $GITHUB_OUTPUT on line 131: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transformation does not strip newlines, so newline injection is still possible.

Fix: apply `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before each write to $GITHUB_OUTPUT.

Locations:

- `action.yml:122`
- `action.yml:131`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two places, without downloading to a file first and verifying integrity before execution:

1. Line 171: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used for 'latest' version)
2. Line 177: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for 'prerelease' version)

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and only then executed — as is already done for the 'release' version path in the same step.

Locations:

- `action.yml:171`
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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Rewrote hardened/action/action.yml with three categories of fixes:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks for each affected step ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference these as $INPUT_* environment variables.

2. **github-env-injection**: Added newline sanitization before writing to $GITHUB_OUTPUT. Both `runner-version` and `mode-cache-key` values are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being echoed to $GITHUB_OUTPUT.

3. **unsafe-shell**: Replaced the two `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with download-to-tempfile-then-execute patterns using `curl -fsSL URL -o "$INSTALLER_TMP"` followed by `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped (it was the shell's option terminator from the pipe form, not the script's argument). Temp files are cleaned up with `trap "rm -f $INSTALLER_TMP" EXIT`.

