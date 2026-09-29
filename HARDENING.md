<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ inputs.* }} expressions are directly interpolated inside run: shell command strings in the 'Determine runner and kernel version' step. Specifically, `${{ inputs.runner-version }}` is assigned to a shell variable on line 96, and `${{ inputs.mode }}` is used inside a command substitution on line 120. These values flow through YAML template substitution before the shell ever sees them, allowing an attacker-controlled value to inject shell metacharacters.

Locations:

- `action.yml:96`
- `action.yml:120`

### script-injection (severity: high)

Rule (a): Multiple ${{ ... }} expressions are directly interpolated inside the run: shell block of the 'Install CodSpeed runner' step. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line 147), `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line 148), `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line 150), and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line ~191). These expressions are substituted by the Actions runner before the shell parses the script, enabling injection of shell metacharacters.

Locations:

- `action.yml:147`
- `action.yml:148`
- `action.yml:150`

### script-injection (severity: high)

Rule (a): The 'Run the benchmarks' step directly interpolates numerous ${{ inputs.* }} expressions inside the run: shell block, including: `${{ inputs.mode }}` (line 221), `${{ inputs.token }}` (line 228), `${{ inputs.working-directory }}` (line 231), `${{ inputs.upload-url }}` (line 234), `${{ inputs.instruments }}` (line 237), `${{ inputs.mongo-uri-env-name }}` (line 240), `${{ inputs.cache-instruments }}` and `${{ inputs.instruments-cache-dir }}` (line 243), `${{ inputs.allow-empty }}` (line 246), `${{ inputs.go-runner-version }}` (line 249), and `${{ inputs.config }}` (line 252). All of these are substituted before shell parsing, allowing injection of arbitrary shell commands by a caller supplying malicious input values.

Locations:

- `action.yml:221`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:246`
- `action.yml:249`
- `action.yml:252`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted values are written to $GITHUB_OUTPUT without sanitization. (1) RUNNER_VERSION is initialized from `${{ inputs.runner-version }}` (line 96) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 115) without applying `printf '%s' | tr -d '\n\r'`. (2) MODE_CACHE_KEY is derived from `${{ inputs.mode }}` (line 120) and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 121) without sanitization. A newline injected into either input could poison subsequent steps that read these outputs.

Locations:

- `action.yml:115`
- `action.yml:121`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (line 156) for the 'latest' version type, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (line 163) for the 'prerelease' version type. In both cases the downloaded script is executed immediately without being saved to a file first and without hash verification, making these paths vulnerable to a compromised or MITM'd remote server delivering malicious content.

Locations:

- `action.yml:156`
- `action.yml:163`

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

Fixed all security findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.) instead of inline template expressions.

2. github-env-injection: Added sanitization with `printf '%s' | tr -d '\n\r'` before writing runner-version and mode-cache-key to $GITHUB_OUTPUT to prevent newline injection attacks.

3. unsafe-shell: Fixed both curl|bash patterns in the 'Install CodSpeed runner' step. For 'latest' and 'prerelease' version types, the script now downloads the installer to a temp file first (curl -fsSL ... -o "$INSTALL_SCRIPT"), then executes it separately (bash "$INSTALL_SCRIPT" --quiet), dropping the -s -- from the original pipe form as required.

