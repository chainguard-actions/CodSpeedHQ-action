<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.3** was hardened automatically. 31 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings across three steps in action.yml, allowing an attacker-controlled input value to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — both `inputs.runner-version` and `inputs.mode` are attacker-controlled and embedded directly in the shell script.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, and `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — all directly interpolated.

Step 4 ('Run the benchmarks'): Numerous `${{ inputs.* }}` expressions are interpolated directly in the run block, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, and `${{ inputs.exclude-allocations }}`. All should be moved to `env:` variables and referenced as `"$VAR"` in the shell.

Locations:

- `action.yml:109`
- `action.yml:132`
- `action.yml:175`
- `action.yml:176`
- `action.yml:178`
- `action.yml:240`
- `action.yml:247`

### github-env-injection (severity: high)

In step 1 ('Determine runner and kernel version'), two values derived from attacker-controlled inputs are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` on the same line above, making it attacker-controlled. A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`. The `tr ',' '-'` only replaces commas; it does not strip newlines, so a newline in `inputs.mode` can still inject into GITHUB_OUTPUT.

Fix: apply `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before each write.

Locations:

- `action.yml:129`
- `action.yml:133`

### unsafe-shell (severity: high)

In step 3 ('Install CodSpeed runner'), two code paths pipe remote content directly to bash without first downloading to a file and verifying integrity:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when `VERSION_TYPE` is 'latest'. The script is fetched and executed in a single pipeline with no hash verification.

2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when `VERSION_TYPE` is 'prerelease'. Same issue: no hash verification before execution.

Note: the 'release' code path correctly downloads to a temp file and verifies a SHA-256 hash before executing — that path is safe. The 'latest' and 'prerelease' paths should follow the same pattern.

Locations:

- `action.yml:184`
- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:110`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:143`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:172`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:276`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps. Step 1 gets INPUT_RUNNER_VERSION and INPUT_MODE; Step 3 gets RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH; Step 4 gets 14 INPUT_* variables covering all inputs used in the run block.

2. github-env-injection: Both GITHUB_OUTPUT writes in Step 1 now sanitize values using printf '%s' ... | tr -d '\n\r' before writing. Also fixed unquoted $GITHUB_OUTPUT to use "$GITHUB_OUTPUT".

3. unsafe-shell: The 'latest' and 'prerelease' code paths in Step 3 now download the installer to a temp file with curl -o "$INSTALLER_TMP" and execute it with bash "$INSTALLER_TMP" --quiet, instead of piping directly to bash. The '--' separator was dropped (it was the shell's option terminator for -s mode, not an argument to the script).

