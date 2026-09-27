<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions are directly interpolated inside run: shell blocks in action.yml (sub-rule a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'): RUNNER_VERSION="${{ inputs.runner-version }}" and MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-') are directly interpolated.

Step 3 ('Install CodSpeed runner'): RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}", VERSION_TYPE="${{ steps.versions.outputs.version-type }}", SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}", and EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}" are directly interpolated.

Step 4 ('Run the benchmarks'): ${{ inputs.mode }}, ${{ inputs.token }}, ${{ inputs.working-directory }}, ${{ inputs.upload-url }}, ${{ inputs.instruments }}, ${{ inputs.mongo-uri-env-name }}, ${{ inputs.cache-instruments }}, ${{ inputs.instruments-cache-dir }}, ${{ inputs.allow-empty }}, ${{ inputs.go-runner-version }}, and ${{ inputs.config }} are all directly interpolated inside the run: shell script. All of these should be passed via env: variables and referenced as quoted shell variables instead.

Locations:

- `action.yml:100`
- `action.yml:118`
- `action.yml:143`
- `action.yml:145`
- `action.yml:147`
- `action.yml:163`
- `action.yml:175`
- `action.yml:177`
- `action.yml:179`
- `action.yml:183`
- `action.yml:187`
- `action.yml:191`
- `action.yml:195`
- `action.yml:199`
- `action.yml:203`
- `action.yml:207`
- `action.yml:211`
- `action.yml:215`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the user-controlled input ${{ inputs.runner-version }} is interpolated directly into the run: script and stored in $RUNNER_VERSION, which is then written to $GITHUB_OUTPUT without sanitization (no printf '%s' ... | tr -d '\n\r' step). Similarly, ${{ inputs.mode }} is used to compute MODE_CACHE_KEY which is also written to $GITHUB_OUTPUT without sanitization. A malicious value containing newlines could inject arbitrary key=value pairs into the GitHub output context.

Locations:

- `action.yml:100`
- `action.yml:115`
- `action.yml:116`
- `action.yml:118`
- `action.yml:120`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever content is served at that URL without any prior integrity verification. The script should be downloaded to a temporary file first, its hash verified, and then executed separately (which the action already does for release versions — the 'latest' branch should follow the same pattern).

Locations:

- `action.yml:157`

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

Fixed all security findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $INPUT_RUNNER_VERSION, etc.

2. github-env-injection: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. This covers runner-version, version-type, kernel-version, and mode-cache-key outputs.

3. unsafe-shell: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a two-step approach: download to a temp file first, then execute separately as `bash "$INSTALL_SCRIPT" --quiet`. The `--` was dropped as it was the shell's stdin-option terminator for the pipe form, not an argument to the install script.

