<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.3** was hardened automatically. 33 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ }}` expressions are interpolated directly inside `run:` shell command strings in the 'Determine runner and kernel version' step. Offending lines include:
- `RUNNER_VERSION="${{ inputs.runner-version }}"`
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

YAML template substitution occurs before the shell parses the string, so an attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can inject arbitrary commands.

Locations:

- `action.yml:108`
- `action.yml:130`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ }}` expressions are interpolated directly inside the `run:` shell block of the 'Install CodSpeed runner' step. Offending lines include:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Direct expression interpolation in a run: block allows shell metacharacter injection before the shell ever quotes the value.

Locations:

- `action.yml:152`
- `action.yml:153`
- `action.yml:155`
- `action.yml:185`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' step interpolates numerous `${{ inputs.* }}` expressions directly inside the `run:` shell block. Offending lines include:
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")`
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")`
- `RUNNER_ARGS+=(--cycle-estimation="${{ inputs.cycle-estimation }}")`
- `RUNNER_ARGS+=(--exclude-allocations="${{ inputs.exclude-allocations }}")`

All of these allow an attacker-controlled input to inject shell metacharacters.

Locations:

- `action.yml:202`
- `action.yml:207`
- `action.yml:210`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (attacker-controlled) and then written unsanitized: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline in the input can inject arbitrary key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (attacker-controlled) via `tr ',' '-'` (which does NOT strip newlines) and then written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline embedded in `inputs.mode` survives the `tr` transformation and can inject additional output variables.

Locations:

- `action.yml:126`
- `action.yml:131`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths without first downloading to a file for verification:

1. Latest version path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the remote install script is executed immediately without any integrity check.

2. Prerelease version path: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions.

If the remote server or network is compromised, arbitrary code can be executed on the runner. The release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the latest and prerelease paths do not.

Locations:

- `action.yml:162`
- `action.yml:168`

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks in three steps: 'Determine runner and kernel version', 'Install CodSpeed runner', and 'Run the benchmarks'. Shell scripts now reference plain environment variables.

2. **github-env-injection**: In 'Determine runner and kernel version', sanitized RUNNER_VERSION with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and MODE_CACHE_KEY with `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'` before writing to $GITHUB_OUTPUT.

3. **unsafe-shell**: Fixed both 'latest' and 'prerelease' install paths in 'Install CodSpeed runner' to download scripts to temp files first (`curl ... -o "$INSTALLER_TMP"`) then execute them (`bash "$INSTALLER_TMP" --quiet`), instead of piping directly to bash. The `--` shell option terminator was correctly dropped since stdin reading mode (-s) is no longer used.

