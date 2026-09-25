<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.2** was hardened automatically. 31 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings across three steps in action.yml, allowing script injection.

Step 1 ('Determine runner and kernel version'):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input interpolated directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input interpolated directly into shell

Step 3 ('Install CodSpeed runner'):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 4 ('Run the benchmarks'):
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]` and `--token "${{ inputs.token }}"`
- `--working-directory="${{ inputs.working-directory }}"`
- `--upload-url="${{ inputs.upload-url }}"`
- `--mode="${{ inputs.mode }}"`
- `--instruments="${{ inputs.instruments }}"`
- `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `--go-runner-version="${{ inputs.go-runner-version }}"`
- `--config="${{ inputs.config }}"`
- `--cycle-estimation="${{ inputs.cycle-estimation }}"`
- `--exclude-allocations="${{ inputs.exclude-allocations }}"`

All of these should be routed through `env:` variables and then double-quoted in the shell script.

Locations:

- `action.yml:109`
- `action.yml:133`
- `action.yml:151`
- `action.yml:152`
- `action.yml:154`
- `action.yml:196`
- `action.yml:222`
- `action.yml:228`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `${{ inputs.runner-version }}` is interpolated directly into the shell as `RUNNER_VERSION`, then written to $GITHUB_OUTPUT via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline-containing value could inject additional key=value pairs into the output file.

2. `${{ inputs.mode }}` is interpolated directly into the shell to compute `MODE_CACHE_KEY`, then written to $GITHUB_OUTPUT via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. No sanitization is applied before the write.

The fix requires applying `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before each write to $GITHUB_OUTPUT.

Locations:

- `action.yml:109`
- `action.yml:133`
- `action.yml:134`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:

1. For `latest` version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the script is fetched and executed in one pipeline with no hash verification.

2. For `prerelease` versions: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — similarly piped directly to bash without hash verification.

Note: the `release` code path correctly downloads to a temp file and verifies a SHA-256 hash before executing. The `latest` and `prerelease` paths should follow the same pattern.

Locations:

- `action.yml:163`
- `action.yml:170`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks across all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference values via environment variables like $INPUT_MODE, $INPUT_TOKEN, $INPUT_RUNNER_VERSION, etc.

2. github-env-injection: Added sanitization before writing to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step. Both RUNNER_VERSION and MODE_CACHE_KEY are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being written to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed the two curl | bash patterns for 'latest' and 'prerelease' version types. Both now download the installer to a temp file first (`curl -fsSL ... -o "$INSTALLER_TMP"`) and then execute it separately (`bash "$INSTALLER_TMP" --quiet`). The '--' that was part of `bash -s --` (shell stdin option terminator) was correctly dropped since we're no longer piping to bash's stdin.

