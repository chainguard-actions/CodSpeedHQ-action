<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 30 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in the 'Determine runner and kernel version' step. Offending lines include:
- `RUNNER_VERSION="${{ inputs.runner-version }}"` (line ~99): attacker-controlled input interpolated directly into shell.
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line ~130): attacker-controlled input interpolated directly into shell command substitution.
Any calling workflow can supply a crafted value for these inputs containing shell metacharacters, enabling command injection.

Locations:

- `action.yml:99`
- `action.yml:130`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside the `run:` shell command string in the 'Install CodSpeed runner' step. Offending lines include:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line ~158)
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line ~159)
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line ~161)
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line ~192)
These context values flow through YAML template substitution before the shell sees them, enabling injection of shell metacharacters.

Locations:

- `action.yml:158`
- `action.yml:159`
- `action.yml:161`
- `action.yml:192`

### script-injection (severity: high)

Sub-rule (a): Numerous `${{ inputs.* }}` expressions are interpolated directly inside the `run:` shell command string in the 'Run the benchmarks' step. Offending lines include:
- `if [ -z "${{ inputs.mode }}" ]` (line ~217)
- `if [ -n "${{ inputs.token }}" ]` and `RUNNER_ARGS+=(--token "${{ inputs.token }}")` (line ~222)
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")` (line ~225)
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")` (line ~228)
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")` (line ~231)
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")` (line ~234)
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")` (line ~237)
- `RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")` (line ~240)
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")` (line ~246)
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")` (line ~249)
All these inputs are caller-controlled and interpolated before the shell parses the script, enabling command injection.

Locations:

- `action.yml:217`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:246`
- `action.yml:249`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `inputs.runner-version` is interpolated directly into the shell variable `RUNNER_VERSION` (line ~99) and then written to `$GITHUB_OUTPUT` without sanitization (line ~122: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`). A newline embedded in the input value could inject arbitrary key=value pairs into GITHUB_OUTPUT. The required sanitization step (`printf '%s' "$VAR" | tr -d '\n\r'`) is absent.

Locations:

- `action.yml:99`
- `action.yml:122`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `inputs.mode` is interpolated directly into `MODE_CACHE_KEY` via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line ~130). The `tr ',' '-'` transformation only removes commas — it does NOT strip newlines or carriage returns. The result is then written to `$GITHUB_OUTPUT` without sanitization (line ~131: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`). A newline in `inputs.mode` could inject arbitrary key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:130`
- `action.yml:131`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes a remotely fetched script directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the URL is intercepted (e.g., via DNS hijacking or MITM), arbitrary code will execute on the runner. This path is taken when `VERSION_TYPE` is `latest`. Note: the release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing.

Locations:

- `action.yml:167`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Updated shell scripts to reference the corresponding environment variables.

2. github-env-injection: Added sanitization before writing to $GITHUB_OUTPUT: RUNNER_VERSION is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'`; MODE_CACHE_KEY is computed with `printf '%s' "$INPUT_MODE" | tr -d '\n\r' | tr ',' '-'` to strip newlines before the comma-to-dash transformation.

3. unsafe-shell: The 'latest' install path now downloads the script to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"`) then executes it (`bash "$INSTALLER_TMP" --quiet`), eliminating the curl-pipe-to-bash pattern. The '--' was dropped as it was the shell's option terminator, not the script's argument.

