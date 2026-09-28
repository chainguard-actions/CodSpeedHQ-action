<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 32 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell blocks.

Step 1 ('Determine runner and kernel version'):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input injected directly into shell
- `DISTRO="${{ runner.os }}"` — expression interpolated directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input injected directly into shell

Step 3 ('Install CodSpeed runner'):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 4 ('Run the benchmarks'): Over a dozen `${{ inputs.* }}` expressions (token, working-directory, upload-url, mode, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config, cycle-estimation, exclude-allocations, simulation-track-subprocess) are interpolated directly into the shell script, allowing an attacker to inject arbitrary shell commands via any of these inputs.

Locations:

- `action.yml:104`
- `action.yml:138`
- `action.yml:141`
- `action.yml:163`
- `action.yml:164`
- `action.yml:166`
- `action.yml:207`
- `action.yml:220`
- `action.yml:224`

### github-env-injection (severity: high)

Step 1 ('Determine runner and kernel version') writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (attacker-controlled) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no sanitization applied before the write.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (attacker-controlled) via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — no sanitization applied before the write.

An attacker can inject newlines into these inputs to poison subsequent steps that read from `$GITHUB_OUTPUT`.

Locations:

- `action.yml:133`
- `action.yml:142`

### unsafe-shell (severity: high)

Step 3 ('Install CodSpeed runner') pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:

1. 'latest' version path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the install script is fetched and executed in one pipeline with no hash verification.

2. 'prerelease' version path: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — similarly piped directly to bash without hash verification.

(Note: the 'release' code path correctly downloads to a temp file and verifies the SHA256 hash before executing — only the 'latest' and 'prerelease' paths are unsafe.)

Locations:

- `action.yml:172`
- `action.yml:178`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:116`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:296`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Rewrote action.yml to fix all security findings:

1. script-injection/static-inline-injection: Moved all ${{ inputs.* }}, ${{ runner.* }}, and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps (Determine runner and kernel version, Install CodSpeed runner, Run the benchmarks). Shell scripts now reference plain $VAR_NAME environment variables.

2. github-env-injection: Added sanitization before writing to $GITHUB_OUTPUT. runner-version uses `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and mode-cache-key uses `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. unsafe-shell: Fixed the 'latest' and 'prerelease' curl|bash patterns by downloading to a temp file first (mktemp + trap for cleanup), then executing with bash. The '--' was correctly dropped since it was the shell's own option terminator for '-s', not an argument to the install script.

4. All ${{ }} expressions remain only in env:, with:, and if: contexts where they are safe — never directly interpolated into shell run: blocks.

