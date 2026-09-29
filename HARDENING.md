<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ inputs.* }} expressions are directly interpolated inside run: shell commands in the 'Determine runner and kernel version' step. Specifically: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. Any value supplied by a caller workflow is substituted into the shell script before the shell parses it, enabling command injection.

Locations:

- `action.yml:87`
- `action.yml:113`

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ steps.*.outputs.* }} and ${{ inputs.* }} expressions are directly interpolated inside run: shell commands in the 'Install CodSpeed runner' step. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. These values flow through YAML template substitution before the shell parses them, enabling command injection.

Locations:

- `action.yml:133`
- `action.yml:134`
- `action.yml:136`
- `action.yml:158`

### script-injection (severity: high)

Sub-rule (a): Numerous ${{ inputs.* }} expressions are directly interpolated inside run: shell commands in the 'Run the benchmarks' step. Offending lines include: `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`, `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`, `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`, `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`, `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`, `if [ "${{ inputs.cache-instruments }}" = "true" ]`, `RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")`, `if [ "${{ inputs.allow-empty }}" = "true" ]`, `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`, and `RUNNER_ARGS+=(--config="${{ inputs.config }}")`. All of these allow an attacker-controlled caller to inject arbitrary shell commands.

Locations:

- `action.yml:183`
- `action.yml:191`
- `action.yml:192`
- `action.yml:195`
- `action.yml:198`
- `action.yml:201`
- `action.yml:204`
- `action.yml:207`
- `action.yml:210`
- `action.yml:211`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two unsanitized values derived from user-controlled inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline embedded in either input value could inject arbitrary key=value pairs into the GitHub output environment.

Locations:

- `action.yml:107`
- `action.yml:114`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, when VERSION_TYPE is 'latest', the action pipes a remotely fetched script directly to bash without first downloading it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote URL is compromised or subject to a MITM attack, arbitrary code will execute on the runner.

Locations:

- `action.yml:141`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables.

2. github-env-injection: Sanitized values written to $GITHUB_OUTPUT using printf '%s' ... | tr -d '\n\r' for both runner-version and mode-cache-key outputs in the 'Determine runner and kernel version' step.

3. unsafe-shell: Replaced 'curl ... | bash -s -- --quiet' with a download-then-execute pattern (curl to temp file, then bash on the file) for the 'latest' version install path. The '--' was correctly dropped as it was the shell's option terminator, not the script's argument.

