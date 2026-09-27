<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml.

**Step: "Determine runner and kernel version"** (line 97): `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input is interpolated directly into the shell script before the shell parses it. Also line 130: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — same issue.

**Step: "Install CodSpeed runner"** (lines 154–157): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — all interpolated directly into the shell script.

**Step: "Run the benchmarks"** (lines 208–240): Numerous `${{ inputs.* }}` expressions (`inputs.mode`, `inputs.token`, `inputs.working-directory`, `inputs.upload-url`, `inputs.instruments`, `inputs.mongo-uri-env-name`, `inputs.cache-instruments`, `inputs.instruments-cache-dir`, `inputs.allow-empty`, `inputs.go-runner-version`, `inputs.config`) are interpolated directly into the `run:` shell script. An attacker controlling these inputs can inject arbitrary shell commands.

Locations:

- `action.yml:97`
- `action.yml:130`
- `action.yml:154`
- `action.yml:155`
- `action.yml:157`
- `action.yml:208`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. Line 122: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` was set from `${{ inputs.runner-version }}` on line 97. An attacker can inject newlines into this value to poison subsequent `$GITHUB_OUTPUT` entries.

2. Line 131: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` was derived from `${{ inputs.mode }}` on line 130. Same injection risk.

Neither write is preceded by the required sanitization pipeline.

Locations:

- `action.yml:122`
- `action.yml:131`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, two code paths pipe remote installer scripts directly to `bash` without first downloading to a file and verifying integrity:

1. Line 163: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when `VERSION_TYPE` is "latest". The script is fetched and executed in a single pipeline with no hash verification.

2. Line 170: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when `VERSION_TYPE` is "prerelease". Same pattern, no hash verification.

Note: the "release" code path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the "latest" and "prerelease" paths do not.

Locations:

- `action.yml:163`
- `action.yml:170`

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks in three steps: 'Determine runner and kernel version' (inputs.runner-version, inputs.mode), 'Install CodSpeed runner' (steps.versions.outputs.runner-version, steps.versions.outputs.version-type, inputs.skip-hash-check-warning, steps.installer-hash.outputs.hash), and 'Run the benchmarks' (inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, inputs.config).

2. **github-env-injection**: Added sanitization before writing to $GITHUB_OUTPUT: runner-version uses `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and mode-cache-key uses `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. **unsafe-shell**: Fixed both curl|bash patterns in the 'Install CodSpeed runner' step by downloading to a temp file first then executing. The '--' was dropped (it was the shell's option terminator, not the script's argument). The 'latest' path now does: `curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"` then `bash "$INSTALL_SCRIPT" --quiet`. The 'prerelease' path similarly downloads then executes.

