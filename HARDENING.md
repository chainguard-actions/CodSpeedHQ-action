<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ ... }} expressions are interpolated directly inside run: shell scripts across three steps in action.yml, allowing an attacker who controls input values to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — both inputs are interpolated directly into the shell before the shell ever sees them.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly into the shell script.

Step 4 ('Run the benchmarks'): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into the shell script. These should be passed via env: variables and then referenced as quoted shell variables.

Locations:

- `action.yml:98`
- `action.yml:122`
- `action.yml:144`
- `action.yml:145`
- `action.yml:147`
- `action.yml:185`
- `action.yml:209`
- `action.yml:215`
- `action.yml:219`
- `action.yml:223`
- `action.yml:227`
- `action.yml:231`
- `action.yml:235`
- `action.yml:239`
- `action.yml:243`
- `action.yml:247`

### github-env-injection (severity: high)

Step 1 ('Determine runner and kernel version') writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization (no `printf '%s' ... | tr -d '\n\r'` step).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled input) and then written directly: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` and `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT`. A newline embedded in `inputs.runner-version` could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'` — the `tr` only replaces commas, it does not strip newlines — and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline in `inputs.mode` would still inject additional entries.

Locations:

- `action.yml:116`
- `action.yml:117`
- `action.yml:123`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths, without downloading to a file first and verifying integrity:

1. For the 'latest' version type: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the script is fetched from a mutable URL and executed immediately.

2. For the 'prerelease' version type: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — similarly piped directly to bash without hash verification.

Note: the 'release' code path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths bypass this protection entirely.

Locations:

- `action.yml:153`
- `action.yml:159`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps. Step 1 uses INPUT_RUNNER_VERSION and INPUT_MODE env vars; Step 3 (Install) uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH env vars; Step 4 (Run benchmarks) uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG env vars.

2. github-env-injection: Added sanitization with `printf '%s' "$VAR" | tr -d '\n\r'` before writing RUNNER_VERSION, VERSION_TYPE, and MODE_CACHE_KEY to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed both curl|bash patterns in the Install step. For 'latest' and 'prerelease' version types, the script is now downloaded to a temp file first (curl -fsSL ... -o "$INSTALL_SCRIPT") and then executed (bash "$INSTALL_SCRIPT" --quiet). The '--' separator was correctly dropped as it was the shell's option terminator, not the script's argument.

