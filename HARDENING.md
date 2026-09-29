<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in the 'Determine runner and kernel version' step. Specifically, `${{ inputs.runner-version }}` is assigned to a shell variable (`RUNNER_VERSION="${{ inputs.runner-version }}"`), and `${{ inputs.mode }}` is used inside a command substitution (`MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`). These template substitutions happen before the shell parses the script, allowing an attacker-controlled input to inject arbitrary shell commands.

Locations:

- `action.yml:95`
- `action.yml:131`

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside the run: shell script in the 'Install CodSpeed runner' step. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:185`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' step directly interpolates numerous ${{ inputs.* }} expressions inside the run: shell script. Offending patterns include: `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`, `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`, `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`, `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`, `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`, `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`, `if [ "${{ inputs.allow-empty }}" = "true" ]`, `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`, and `RUNNER_ARGS+=(--config="${{ inputs.config }}")`. Any of these inputs can contain shell metacharacters injected by a calling workflow.

Locations:

- `action.yml:210`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no `tr -d '\n\r'` sanitization is applied. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — again without sanitization. A newline embedded in either input could inject additional key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:120`
- `action.yml:133`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, the script pipes a remotely fetched installer script directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever content is served at that URL without first saving it to a file for inspection or hash verification. If the remote URL is compromised or subject to a MITM attack, arbitrary code would execute on the runner. (Note: the release-version code path does correctly download to a temp file and verify a SHA256 hash before executing — but the 'latest' version code path does not.)

Locations:

- `action.yml:160`

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

Fixed all security findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $RUNNER_VERSION, etc.

2. github-env-injection: Added sanitization with `printf '%s' "$VAR" | tr -d '\n\r'` before writing runner-version and mode-cache-key to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step.

3. unsafe-shell: Fixed the curl|bash pattern in the 'latest' version code path of 'Install CodSpeed runner'. Now downloads install.sh to a temp file first, then executes it separately. Dropped the '--' that was the shell's option terminator in the pipe form (the script receives --quiet directly as $1).

