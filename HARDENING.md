<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote scripts directly to bash without first downloading to a file. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version type, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for the 'prerelease' version type. An attacker who can intercept or compromise the remote URL can execute arbitrary code on the runner.

Locations:

- `action.yml:155`
- `action.yml:163`

### script-injection (severity: high)

Sub-rule (a): The 'Determine runner and kernel version' step directly interpolates `${{ inputs.runner-version }}` and `${{ inputs.mode }}` inside the `run:` shell block. A calling workflow can supply a value containing shell metacharacters (e.g. `$(command)`, backticks, `;`) that will be executed by the shell before any quoting takes effect. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:96`
- `action.yml:119`

### script-injection (severity: high)

Sub-rule (a): The 'Install CodSpeed runner' step directly interpolates `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` inside the `run:` shell block. These values flow from caller-controlled inputs and step outputs and are expanded by the YAML template engine before the shell sees them, enabling script injection.

Locations:

- `action.yml:140`
- `action.yml:141`
- `action.yml:143`
- `action.yml:185`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' step directly interpolates multiple `${{ inputs.* }}` expressions inside the `run:` shell block, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. Any of these can contain shell metacharacters that are interpreted before the shell quotes them, enabling command injection by a calling workflow.

Locations:

- `action.yml:203`
- `action.yml:209`
- `action.yml:213`
- `action.yml:217`
- `action.yml:221`
- `action.yml:225`
- `action.yml:229`
- `action.yml:233`
- `action.yml:237`
- `action.yml:241`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input can inject additional output variables. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step.

Locations:

- `action.yml:121`
- `action.yml:122`
- `action.yml:124`

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

**Fixes applied:** unsafe-shell, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. unsafe-shell: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with download-then-execute patterns using mktemp temp files. The '--' was dropped as it was the shell's option terminator for the pipe form, not an argument to the install script.

2. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks for all three affected steps: 'Determine runner and kernel version', 'Install CodSpeed runner', and 'Run the benchmarks'. Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.).

3. github-env-injection: Values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being written, preventing newline injection that could inject additional output variables.

