<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings in action.yml, violating rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line ~101): `RUNNER_VERSION="${{ inputs.runner-version }}"` and (line ~134): `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

Step 'Install CodSpeed runner' (lines ~160-163): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and (line ~207): `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 'Run the benchmarks' (lines ~215-240): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}` are all interpolated directly into the shell script. All of these should be passed via env: variables and then referenced as quoted shell variables.

Locations:

- `action.yml:101`
- `action.yml:134`
- `action.yml:160`
- `action.yml:161`
- `action.yml:163`
- `action.yml:215`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:246`
- `action.yml:249`

### github-env-injection (severity: high)

Untrusted input values are written to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r').

1. In the 'Determine runner and kernel version' step: `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line ~101) and then written unsanitized to $GITHUB_OUTPUT via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line ~126). An attacker-controlled newline in the input can inject arbitrary key=value pairs into the GitHub output context.

2. In the same step: `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line ~134) and written unsanitized to $GITHUB_OUTPUT via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line ~135). The `tr ',' '-'` transformation does not strip newlines, so a newline in `inputs.mode` still enables injection.

Locations:

- `action.yml:126`
- `action.yml:135`

### unsafe-shell (severity: high)

Remote scripts are downloaded and piped directly to bash without hash verification in two code paths of the 'Install CodSpeed runner' step:

1. When runner-version is 'latest': `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (line ~169). The script is fetched from a remote URL and executed immediately without any integrity check.

2. When runner-version is a prerelease: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (line ~175). Same pattern — no hash verification before execution.

The script should be downloaded to a temporary file first, its hash verified against a known-good value, and only then executed (as is done for the release code path).

Locations:

- `action.yml:169`
- `action.yml:175`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks. Added INPUT_RUNNER_VERSION, INPUT_MODE to 'Determine runner and kernel version' step; INPUT_RUNNER_VERSION, INPUT_VERSION_TYPE, INPUT_SKIP_HASH_CHECK_WARNING, INPUT_INSTALLER_HASH to 'Install CodSpeed runner' step; and INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG to 'Run the benchmarks' step. All shell references updated to use $INPUT_* variables.

2. github-env-injection: Sanitized RUNNER_VERSION before writing to GITHUB_OUTPUT using `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'`. Sanitized MODE_CACHE_KEY using `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. unsafe-shell: Replaced both `curl | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with download-to-temp-file-then-execute patterns: `curl -fsSL ... -o "$INSTALLER_TMP"` followed by `bash "$INSTALLER_TMP" --quiet`. The `--` was dropped as it was the shell's option terminator for the piped form, not an argument to the installer script.

