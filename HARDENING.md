<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): The 'Determine runner and kernel version' run: block directly interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} into shell commands. These are caller-controlled values that are expanded by the YAML template engine before the shell ever sees them, allowing an attacker to inject arbitrary shell metacharacters. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:96`
- `action.yml:118`

### script-injection (severity: high)

Rule (a): The 'Install CodSpeed runner' run: block directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} into shell commands. steps.*.outputs.* and inputs.* are workflow-controllable and flow through YAML template substitution before the shell parses them. Offending lines: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:139`
- `action.yml:140`
- `action.yml:142`
- `action.yml:183`

### script-injection (severity: high)

Rule (a): The 'Run the benchmarks' run: block directly interpolates multiple ${{ inputs.* }} expressions into shell commands, including inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, and inputs.config. All of these are caller-controlled and are expanded by the YAML template engine before the shell parses them, enabling shell command injection. Example offending lines: `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`, etc.

Locations:

- `action.yml:207`
- `action.yml:215`
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

The 'Determine runner and kernel version' run: block writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization. (1) RUNNER_VERSION is initialized from ${{ inputs.runner-version }} (directly interpolated) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without applying `printf '%s' ... | tr -d '\n\r'`. (2) MODE_CACHE_KEY is derived from ${{ inputs.mode }} and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline embedded in either input value can inject additional key=value pairs into GITHUB_OUTPUT, poisoning downstream steps.

Locations:

- `action.yml:113`
- `action.yml:119`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' run: block pipes remote content directly to bash in two code paths: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when runner-version is 'latest') and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for prerelease versions). If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner. The script should be downloaded to a temporary file, its integrity verified, and then executed separately — as the action already does correctly for release versions.

Locations:

- `action.yml:148`
- `action.yml:155`

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

Fixed all findings in action.yml:

1. 'Determine runner and kernel version' step: Moved ${{ inputs.runner-version }} and ${{ inputs.mode }} to env: block as INPUT_RUNNER_VERSION and INPUT_MODE. Added printf/tr sanitization before writing to $GITHUB_OUTPUT to prevent newline injection.

2. 'Install CodSpeed runner' step: Moved ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} to env: block. Fixed two unsafe curl|bash patterns by downloading scripts to temp files first then executing separately (dropping the '--' separator per instructions).

3. 'Run the benchmarks' step: Moved all 11 ${{ inputs.* }} expressions (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) to env: block with INPUT_* naming, and updated all shell references accordingly.

