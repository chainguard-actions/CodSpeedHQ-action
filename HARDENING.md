<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ inputs.* }} expressions are directly interpolated inside run: shell command strings in the 'Determine runner and kernel version' step. Specifically: `RUNNER_VERSION="${{ inputs.runner-version }}"` (line 97) and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line 128). An attacker-controlled input value is expanded by the YAML template engine before the shell ever sees it, enabling shell metacharacter injection.

Locations:

- `action.yml:97`
- `action.yml:128`

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside the run: shell command string in the 'Install CodSpeed runner' step. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line 154), `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line 155), `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line 157), and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line 195). These values flow through YAML template substitution before the shell parses them, enabling injection of shell metacharacters.

Locations:

- `action.yml:154`
- `action.yml:155`
- `action.yml:157`
- `action.yml:195`

### script-injection (severity: high)

Sub-rule (a): Numerous ${{ inputs.* }} expressions are directly interpolated inside the run: shell command string in the 'Run the benchmarks' step. Examples include: `if [ -z "${{ inputs.mode }}" ]` (line 221), `if [ -n "${{ inputs.token }}" ]` / `--token "${{ inputs.token }}"` (lines 228-229), `--working-directory="${{ inputs.working-directory }}"` (line 232), `--upload-url="${{ inputs.upload-url }}"` (line 235), `--mode="${{ inputs.mode }}"` (line 238), `--instruments="${{ inputs.instruments }}"` (line 241), `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"` (line 244), `if [ "${{ inputs.cache-instruments }}" = "true" ]` (line 246), `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"` (line 247), `if [ "${{ inputs.allow-empty }}" = "true" ]` (line 249), `--go-runner-version="${{ inputs.go-runner-version }}"` (line 253), `--config="${{ inputs.config }}"` (line 256). All of these allow an attacker-supplied input to inject shell metacharacters.

Locations:

- `action.yml:221`
- `action.yml:228`
- `action.yml:229`
- `action.yml:232`
- `action.yml:235`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:246`
- `action.yml:247`
- `action.yml:249`
- `action.yml:253`
- `action.yml:256`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 97) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 120) and `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` (line 121) — both without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line 128) and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 129) — also without sanitization. A newline character in either input could inject arbitrary key=value pairs into $GITHUB_OUTPUT.

Locations:

- `action.yml:120`
- `action.yml:121`
- `action.yml:129`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, remote content is fetched and piped directly to bash without first saving to a file and verifying integrity: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This pattern executes whatever the remote server returns, making it vulnerable to supply-chain attacks (e.g., DNS hijacking, CDN compromise, or MITM). The release-version code path correctly downloads to a temp file and verifies a SHA-256 hash, but the 'latest' version path bypasses this protection entirely.

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

Fixed all findings in action.yml:

1. **Determine runner and kernel version step**: Moved ${{ inputs.runner-version }} and ${{ inputs.mode }} to env: block as INPUT_RUNNER_VERSION and INPUT_MODE. Added printf '%s' ... | tr -d '\n\r' sanitization before writing runner-version, version-type, and mode-cache-key to $GITHUB_OUTPUT. Quoted $GITHUB_OUTPUT references.

2. **Install CodSpeed runner step**: Moved ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} to env: block. Removed the now-redundant inline EXPECTED_HASH assignment. Fixed unsafe-shell by downloading install.sh to a temp file first (curl -fsSL ... -o "$LATEST_INSTALLER_TMP") then executing it (bash "$LATEST_INSTALLER_TMP" --quiet) instead of piping curl to bash. Dropped the '--' from the original 'bash -s -- --quiet' as it was the shell's option terminator, not the script's argument.

3. **Run the benchmarks step**: Moved all ${{ inputs.* }} expressions (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) to the env: block and updated all shell script references to use the corresponding $INPUT_* environment variables.

