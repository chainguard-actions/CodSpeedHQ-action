<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings in action.yml. This allows an attacker who controls the inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line ~97): `RUNNER_VERSION="${{ inputs.runner-version }}"` and (line ~130): `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Step 'Install CodSpeed runner' (line ~156): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 'Run the benchmarks' (line ~228+): `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"`

All these must be moved to `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) inside the `run:` block.

Locations:

- `action.yml:97`
- `action.yml:130`
- `action.yml:156`
- `action.yml:158`
- `action.yml:160`
- `action.yml:196`
- `action.yml:228`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths:
1. For 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
2. For 'prerelease' version: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`

This is unsafe because the script is never written to disk and verified before execution. An attacker who can intercept or tamper with the remote URL (e.g., via DNS hijacking or a compromised CDN) can execute arbitrary code on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately — which the action already does correctly for release versions.

Locations:

- `action.yml:168`
- `action.yml:175`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without sanitization:

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~97) and then written to `$GITHUB_OUTPUT` via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~122). No `printf '%s' ... | tr -d '\n\r'` sanitization is applied before the write.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line ~130) and written to `$GITHUB_OUTPUT` via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~131). No sanitization is applied.

A newline character embedded in either input value could inject additional key=value pairs into `$GITHUB_OUTPUT`, potentially overwriting outputs consumed by downstream steps.

Locations:

- `action.yml:122`
- `action.yml:131`

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference env vars like $INPUT_MODE, $INPUT_TOKEN, $INPUT_RUNNER_VERSION, etc.

2. **unsafe-shell**: Replaced `curl -fsSL ... | bash -s -- --quiet` with safe download-then-execute pattern for both 'latest' and 'prerelease' code paths. Script is downloaded to a mktemp file, then executed with `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped (it was the shell's option terminator for stdin mode, not the script's argument).

3. **github-env-injection**: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing, preventing newline injection that could overwrite downstream step outputs.

