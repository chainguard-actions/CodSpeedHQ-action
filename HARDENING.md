<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings in action.yml, enabling script injection. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly into the shell. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are interpolated directly. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into the shell script. An attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can execute arbitrary commands.

Locations:

- `action.yml:103`
- `action.yml:133`
- `action.yml:163`
- `action.yml:240`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version path, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for the 'prerelease' version path. If the remote server is compromised or the URL is intercepted (e.g., via MITM), arbitrary code will be executed on the runner without any integrity check.

Locations:

- `action.yml:170`
- `action.yml:178`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to $GITHUB_OUTPUT without newline sanitization: (1) `inputs.runner-version` is interpolated into `$RUNNER_VERSION` via `RUNNER_VERSION="${{ inputs.runner-version }}"` and then written with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no `tr -d '\n\r'` sanitization is applied before the write. (2) `inputs.mode` is processed into `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — the `tr ',' '-'` only strips commas, not newlines, so a newline-containing input can inject additional key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:126`
- `action.yml:133`

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

**Fixes applied:** script-injection, static-inline-injection, unsafe-shell, github-env-injection

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. script-injection/static-inline-injection: Moved all ${{ }} expressions from run: blocks to env: blocks across three steps:
   - 'Determine runner and kernel version': inputs.runner-version → INPUT_RUNNER_VERSION, inputs.mode → INPUT_MODE
   - 'Install CodSpeed runner': moved runner-version, version-type, skip-hash-check-warning, and installer-hash outputs to env: block
   - 'Run the benchmarks': moved all 11 inputs (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) to env: block with INPUT_* naming

2. unsafe-shell: Fixed both curl|bash patterns in 'Install CodSpeed runner' by downloading scripts to temp files first, then executing. The '--' was correctly dropped (it was the shell's own option terminator, not the script's argument).

3. github-env-injection: Added newline sanitization (tr -d '\n\r') before writing runner-version and mode-cache-key to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step.

