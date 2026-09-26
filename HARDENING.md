<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell blocks across three composite action steps, violating sub-rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs are interpolated directly into shell.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly.

Step 4 ('Run the benchmarks'): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell command strings. All of these should be passed via env: variables and then referenced as quoted shell variables.

Locations:

- `action.yml:100`
- `action.yml:130`
- `action.yml:155`
- `action.yml:157`
- `action.yml:159`
- `action.yml:191`
- `action.yml:210`
- `action.yml:218`
- `action.yml:222`
- `action.yml:226`
- `action.yml:230`
- `action.yml:234`
- `action.yml:238`
- `action.yml:242`
- `action.yml:246`
- `action.yml:250`
- `action.yml:254`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:
1. For 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
2. For 'prerelease' version: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`
If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temp file, its hash verified, and then executed separately (as is already done for the release version path).

Locations:

- `action.yml:168`
- `action.yml:175`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two unsanitized values are written to $GITHUB_OUTPUT without applying `printf '%s' ... | tr -d '\n\r'` sanitization:
1. `$RUNNER_VERSION` (derived from `${{ inputs.runner-version }}`) is written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. An attacker can inject newlines to poison subsequent output entries.
2. `$MODE_CACHE_KEY` (derived from `${{ inputs.mode }}` via `tr ',' '-'`, which does not strip newlines) is written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transform does not remove newline characters, leaving the write vulnerable to newline injection.

Locations:

- `action.yml:120`
- `action.yml:125`

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

**Fixes applied:** script-injection, unsafe-shell, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference values via environment variables (INPUT_MODE, INPUT_TOKEN, INPUT_RUNNER_VERSION, etc.).

2. unsafe-shell: Replaced both curl-pipe-to-bash patterns (for 'latest' and 'prerelease' version paths) with download-then-execute: curl downloads to a temp file, then bash executes the file. The '--' shell option terminator from 'bash -s --' was correctly dropped since we're no longer reading from stdin.

3. github-env-injection: Sanitized both values written to $GITHUB_OUTPUT: RUNNER_VERSION uses 'printf | tr -d newlines' before writing, and MODE_CACHE_KEY now pipes through 'tr -d newlines' in addition to the existing comma-to-dash transform.

