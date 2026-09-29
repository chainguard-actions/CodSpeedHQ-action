<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions from inputs.* and steps.*.outputs.* contexts are interpolated directly inside run: shell command strings in action.yml. This allows an attacker who controls these inputs to inject arbitrary shell commands. Affected lines include:
- Line 96: `RUNNER_VERSION="${{ inputs.runner-version }}"`
- Line 116: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`
- Line 143: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- Line 144: `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- Line 146: `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- Line 183: `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`
- Line 197: `if [ -z "${{ inputs.mode }}" ]`
- Lines 203–230: Multiple `RUNNER_ARGS+=(... "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`, `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`, `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`, `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")`, `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")`, `RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")`, `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")`, `RUNNER_ARGS+=(--config="${{ inputs.config }}")`
All these values should be passed via env: variables and referenced as quoted shell variables instead.

Locations:

- `action.yml:96`
- `action.yml:116`
- `action.yml:143`
- `action.yml:144`
- `action.yml:146`
- `action.yml:183`
- `action.yml:197`
- `action.yml:203`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r'):
1. `${{ inputs.runner-version }}` is assigned to RUNNER_VERSION (line 96) and then written to $GITHUB_OUTPUT via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 112). A newline embedded in the input can inject additional key=value pairs into GITHUB_OUTPUT.
2. `${{ inputs.mode }}` is used to compute MODE_CACHE_KEY (line 116) and then written to $GITHUB_OUTPUT via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 117). Same injection risk applies.

Locations:

- `action.yml:112`
- `action.yml:117`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote scripts directly to bash without first downloading to a file and verifying integrity:
1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when VERSION_TYPE=latest) — the remote script is executed immediately without any hash verification.
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used when VERSION_TYPE=prerelease) — same pattern, no hash verification.
If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately.

Locations:

- `action.yml:152`
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

Fixed all findings in action.yml:

1. **script-injection / static-inline-injection** (all locations): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell scripts into env: blocks. Step 'Determine runner and kernel version' now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. Step 'Install CodSpeed runner' now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. Step 'Run the benchmarks' now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. **github-env-injection** (lines 112, 117): Added sanitization using `printf '%s' "$VAR" | tr -d '\n\r'` before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. **unsafe-shell** (lines 152, 159): Replaced `curl ... | bash -s -- --quiet` with download-then-execute pattern: `curl -fsSL URL -o "$INSTALLER_TMP"` followed by `bash "$INSTALLER_TMP" --quiet`. The `--` shell option terminator was correctly dropped as it was the shell's own separator, not the script's argument.

