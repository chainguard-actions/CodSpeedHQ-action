<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml, violating rule (a). This allows an attacker who controls the inputs to inject arbitrary shell commands.

1. Step 'Determine runner and kernel version': `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs.runner-version and inputs.mode are interpolated directly into the shell script.

2. Step 'Install CodSpeed runner': `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly.

3. Step 'Run the benchmarks': `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into the shell script.

All these should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR").

Locations:

- `action.yml:99`
- `action.yml:120`
- `action.yml:160`
- `action.yml:161`
- `action.yml:163`
- `action.yml:192`
- `action.yml:213`
- `action.yml:218`
- `action.yml:222`
- `action.yml:226`
- `action.yml:230`
- `action.yml:234`
- `action.yml:238`
- `action.yml:242`
- `action.yml:246`
- `action.yml:250`
- `action.yml:254`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the value of inputs.runner-version (untrusted) is assigned to RUNNER_VERSION and then written to $GITHUB_OUTPUT without sanitization: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. Similarly, inputs.mode (untrusted) is used to compute MODE_CACHE_KEY and written to $GITHUB_OUTPUT: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:113`
- `action.yml:121`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths:
1. For 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — downloads and executes a remote script without any integrity verification.
2. For 'prerelease' version: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — downloads and executes a versioned remote script without hash verification.

If the remote server or DNS is compromised, arbitrary code could be executed on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as is already done for the 'release' version type).

Locations:

- `action.yml:172`
- `action.yml:179`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks. The 'Determine runner and kernel version' step now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. The 'Install CodSpeed runner' step now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. The 'Run the benchmarks' step now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. github-env-injection: All values written to $GITHUB_OUTPUT are now sanitized with 'printf \'%s\' "$VAR" | tr -d \'\n\r\'' before writing. The mode-cache-key computation now uses printf+tr on INPUT_MODE instead of directly interpolating ${{ inputs.mode }}.

3. unsafe-shell: Replaced 'curl ... | bash -s -- --quiet' patterns for 'latest' and 'prerelease' version types with download-to-tempfile-then-execute pattern. The '--' was correctly dropped (it was the shell's option terminator, not the script's argument). The release version path already used the secure download+verify+execute pattern and was preserved.

