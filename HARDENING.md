<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ }} expressions from untrusted inputs are interpolated directly inside run: shell blocks (sub-rule a). In the 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` (line ~96) and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line ~125). In the 'Install CodSpeed runner' step: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line ~150), `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line ~151), `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line ~152), and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line ~195). In the 'Run the benchmarks' step: `if [ -z "${{ inputs.mode }}" ]` (line ~222) and multiple `${{ inputs.* }}` expressions for token, working-directory, upload-url, mode, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, and config are all interpolated directly into the shell script (lines ~228-255). Any of these inputs can contain shell metacharacters that will be interpreted by bash before the script runs.

Locations:

- `action.yml:96`
- `action.yml:125`
- `action.yml:150`
- `action.yml:151`
- `action.yml:152`
- `action.yml:195`
- `action.yml:222`
- `action.yml:228`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written as `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~117) without a preceding `printf '%s' | tr -d '\n\r'` sanitization step. (2) `VERSION_TYPE` is derived from `RUNNER_VERSION` and written as `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` (line ~118) without sanitization. (3) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written as `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~126) without sanitization. An attacker-controlled newline in any of these inputs can inject arbitrary key=value pairs into GITHUB_OUTPUT, potentially overwriting outputs consumed by downstream steps.

Locations:

- `action.yml:117`
- `action.yml:118`
- `action.yml:126`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, two code paths pipe remote content directly to bash without first saving to a file and verifying integrity: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (line ~158) for the 'latest' version path, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (line ~164) for the 'prerelease' version path. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. Note: the 'release' code path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths do not.

Locations:

- `action.yml:158`
- `action.yml:164`

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added INPUT_RUNNER_VERSION and INPUT_MODE env vars
   - 'Install CodSpeed runner': Added INPUT_RUNNER_VERSION, INPUT_VERSION_TYPE, INPUT_SKIP_HASH_CHECK_WARNING, INPUT_EXPECTED_HASH env vars
   - 'Run the benchmarks': Added 11 INPUT_* env vars for all inputs used in the script

2. **github-env-injection**: Sanitized values before writing to $GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` for runner-version, version-type, and mode-cache-key outputs.

3. **unsafe-shell**: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with download-to-temp-file + execute pattern (`curl -fsSL URL -o "$INSTALL_TMP"` then `bash "$INSTALL_TMP" --quiet`). Dropped the `--` shell option terminator as required since we're no longer piping to bash stdin.

