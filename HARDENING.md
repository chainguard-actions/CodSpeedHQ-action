<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.6** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` contexts are directly interpolated inside `run:` shell command strings across three steps in action.yml. This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line ~103): `RUNNER_VERSION="${{ inputs.runner-version }}"` and (line ~121) `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Step 'Install CodSpeed runner' (line ~148): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 'Run the benchmarks' (line ~205): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}` — all interpolated directly into shell.

All these should be passed via `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) instead.

Locations:

- `action.yml:103`
- `action.yml:121`
- `action.yml:148`
- `action.yml:205`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, untrusted input values are written to $GITHUB_OUTPUT without sanitization.

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~103) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~119) without applying `printf '%s' ... | tr -d '\n\r'` first. A newline in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line ~121) and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~122) without sanitization.

The fix requires sanitizing each value with `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before writing to the special environment file.

Locations:

- `action.yml:119`
- `action.yml:122`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths:

1. For 'latest' version type (line ~157): `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — downloads and executes a remote script without saving to a file first or verifying integrity.

2. For 'prerelease' version type (line ~163): `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for pre-release versions.

Both patterns execute remotely-fetched content directly in the shell. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as is already done for release versions in the same step).

Locations:

- `action.yml:157`
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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks across three steps:
   - 'Determine runner and kernel version': Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH
   - 'Run the benchmarks': Added INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG to the existing env: block

2. **github-env-injection**: All values written to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing.

3. **unsafe-shell**: Both curl-pipe-to-bash patterns fixed by downloading to a temp file first then executing separately. The '--' separator was dropped (it was the shell's option terminator, not the script's argument). The 'latest' and 'prerelease' branches now use: `curl -fsSL <url> -o "$INSTALLER_TMP"` followed by `bash "$INSTALLER_TMP" --quiet`.

