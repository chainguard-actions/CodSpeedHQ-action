<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Direct ${{ }} expression interpolation inside run: blocks. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` is interpolated directly into the shell script as `RUNNER_VERSION="${{ inputs.runner-version }}"`, and `${{ inputs.mode }}` is interpolated in `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. An attacker-controlled input value containing shell metacharacters (`;`, `$(...)`, backticks, etc.) is expanded by the shell before any quoting can protect it.

Locations:

- `action.yml:97`
- `action.yml:130`

### script-injection (severity: high)

Sub-rule (a): Direct ${{ }} expression interpolation inside run: blocks. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, and `${{ inputs.skip-hash-check-warning }}` are all interpolated directly into the shell script (e.g. `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`). These values flow from user-controlled inputs and are expanded by the shell before quoting takes effect.

Locations:

- `action.yml:163`
- `action.yml:164`
- `action.yml:166`

### script-injection (severity: high)

Sub-rule (a): Direct ${{ }} expression interpolation inside run: blocks. In the 'Run the benchmarks' step, numerous `inputs.*` values are interpolated directly into the shell script, including: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. Each of these is substituted into the shell command string before the shell parses it, allowing injection of arbitrary shell metacharacters.

Locations:

- `action.yml:230`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`
- `action.yml:256`
- `action.yml:259`
- `action.yml:262`
- `action.yml:265`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the variable RUNNER_VERSION is derived directly from `${{ inputs.runner-version }}` (an attacker-controlled input) and then written unsanitized to $GITHUB_OUTPUT: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. Similarly, MODE_CACHE_KEY is derived from `${{ inputs.mode }}` and written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline-containing input value could inject arbitrary key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:120`
- `action.yml:131`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths without downloading to a file first: (1) For the 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. (2) For prerelease versions: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code executes immediately on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the latest and prerelease paths do not.

Locations:

- `action.yml:175`
- `action.yml:182`

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

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain $ENV_VAR names.

2. github-env-injection: In 'Determine runner and kernel version', sanitized RUNNER_VERSION and INPUT_MODE with `printf '%s' "$VAR" | tr -d '\n\r'` before writing to $GITHUB_OUTPUT.

3. unsafe-shell: In 'Install CodSpeed runner', replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with download-to-temp-file-then-execute patterns using mktemp + trap for cleanup. The '--' was dropped as it was the shell's option terminator, not the script's argument.

