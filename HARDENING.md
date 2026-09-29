<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.6** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Determine runner and kernel version' run: block directly interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} into shell commands. An attacker controlling these inputs can inject arbitrary shell commands. Offending lines include: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:100`
- `action.yml:127`

### script-injection (severity: high)

Sub-rule (a): The 'Install CodSpeed runner' run: block directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} into shell commands. These step outputs are derived from user-controlled inputs and can be used to inject arbitrary shell commands. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:183`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' run: block directly interpolates numerous ${{ inputs.* }} expressions into shell commands, including ${{ inputs.mode }}, ${{ inputs.token }}, ${{ inputs.working-directory }}, ${{ inputs.upload-url }}, ${{ inputs.instruments }}, ${{ inputs.mongo-uri-env-name }}, ${{ inputs.cache-instruments }}, ${{ inputs.instruments-cache-dir }}, ${{ inputs.allow-empty }}, ${{ inputs.go-runner-version }}, and ${{ inputs.config }}. An attacker controlling any of these inputs can inject arbitrary shell commands. For example: `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")` and `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")` etc.

Locations:

- `action.yml:222`
- `action.yml:226`
- `action.yml:229`
- `action.yml:232`
- `action.yml:235`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' run: block writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization. Specifically: (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written as `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input can inject additional output variables. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (via `tr ',' '-'`, which does not strip newlines) and written as `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step.

Locations:

- `action.yml:128`
- `action.yml:129`
- `action.yml:133`
- `action.yml:135`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' run: block pipes remote content directly to bash in two places: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — fetches and executes a remote install script without downloading to a file first; (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner.

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell scripts into env: blocks for three steps: 'Determine runner and kernel version' (inputs.runner-version, inputs.mode), 'Install CodSpeed runner' (steps.versions.outputs.runner-version, steps.versions.outputs.version-type, inputs.skip-hash-check-warning, steps.installer-hash.outputs.hash), and 'Run the benchmarks' (inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, inputs.config). Shell scripts now reference plain $ENV_VAR names.

2. github-env-injection: All values written to $GITHUB_OUTPUT in 'Determine runner and kernel version' are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being echoed. The mode cache key computation also strips newlines before the comma-to-dash transformation.

3. unsafe-shell: Both `curl ... | bash -s -- --quiet` patterns replaced with download-then-execute: script downloaded to mktemp file, then executed with `bash "$INSTALL_SCRIPT" --quiet`. The `--` shell option terminator was dropped (correct per guidelines — it was the shell's option terminator, not the script's argument).

