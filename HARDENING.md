<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.0** was hardened automatically. 33 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in the 'Determine runner and kernel version' step. Offending lines include:
- `RUNNER_VERSION="${{ inputs.runner-version }}"` (line 111)
- `DISTRO="${{ runner.os }}"` (line 131)
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line 135)
Any of these inputs can contain shell metacharacters that are evaluated by bash before the script runs.

Locations:

- `action.yml:111`
- `action.yml:131`
- `action.yml:135`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in the 'Install CodSpeed runner' step. Offending lines include:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line 163)
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line 164)
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line 166)
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line 207)
These values flow through YAML template substitution before the shell ever sees them, allowing injection of shell metacharacters.

Locations:

- `action.yml:163`
- `action.yml:164`
- `action.yml:166`
- `action.yml:207`

### script-injection (severity: high)

Sub-rule (a): Numerous `${{ inputs.* }}` expressions are interpolated directly inside the `run:` shell command string in the 'Run the benchmarks' step. Offending expressions include `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}`. An attacker-controlled input value containing shell metacharacters (e.g. `"; malicious-cmd #`) would be executed by the shell.

Locations:

- `action.yml:222`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:246`
- `action.yml:249`
- `action.yml:252`
- `action.yml:255`
- `action.yml:258`
- `action.yml:261`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` is interpolated directly into the shell variable `RUNNER_VERSION` and then written to `$GITHUB_OUTPUT` (e.g. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`) without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline-containing input value could inject arbitrary key=value pairs into the GitHub output context. Similarly, `${{ inputs.mode }}` is interpolated into `MODE_CACHE_KEY` and written to `$GITHUB_OUTPUT` without sanitization.

Locations:

- `action.yml:131`
- `action.yml:132`
- `action.yml:135`
- `action.yml:147`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash without downloading to a file first. Two occurrences:
1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (for 'latest' version mode) — the remote script is executed immediately without any integrity check.
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (for 'prerelease' version mode) — the remote script is executed immediately without any integrity check.
A compromised or MITM'd remote server could serve malicious content that would be executed directly on the runner.

Locations:

- `action.yml:172`
- `action.yml:179`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:110`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:153`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:182`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ ... }} expressions out of run: shell strings into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain $VAR_NAME environment variables.

2. **github-env-injection**: All values written to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing, preventing newline injection attacks.

3. **unsafe-shell**: Both `curl ... | bash -s -- --quiet` occurrences (for 'latest' and 'prerelease' version types) were replaced with: download to a temp file using `curl -fsSL URL -o "$INSTALL_SCRIPT"`, then execute with `bash "$INSTALL_SCRIPT" --quiet`. The `--` was dropped as it was the shell's option terminator (from the pipe form `-s --`), not an argument to the install script.

