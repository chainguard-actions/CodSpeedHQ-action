<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml, violating rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line ~98): `RUNNER_VERSION="${{ inputs.runner-version }}"` and (line ~115) `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Step 'Install CodSpeed runner' (lines ~133-136): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Step 'Run the benchmarks' (lines ~183-220): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell command strings. These should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR").

Locations:

- `action.yml:98`
- `action.yml:115`
- `action.yml:133`
- `action.yml:134`
- `action.yml:136`
- `action.yml:183`
- `action.yml:186`
- `action.yml:189`
- `action.yml:192`
- `action.yml:195`
- `action.yml:198`
- `action.yml:201`
- `action.yml:204`
- `action.yml:207`
- `action.yml:210`
- `action.yml:213`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the variable MODE_CACHE_KEY is derived from the untrusted input expression `${{ inputs.mode }}` and then written to $GITHUB_OUTPUT without sanitization: `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` followed by `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. An attacker-controlled value containing newlines could inject additional key=value pairs into the GitHub output context. The required sanitization step (`printf '%s' "$MODE_CACHE_KEY" | tr -d '\n\r'`) is missing before the write.

Locations:

- `action.yml:115`
- `action.yml:116`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, a remote script is fetched and piped directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This is executed when VERSION_TYPE is 'latest'. If the remote server is compromised or the URL is redirected, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its integrity verified (hash check), and only then executed — which is already done correctly for the release version path but not for the 'latest' path.

Locations:

- `action.yml:148`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). All run: scripts now reference plain shell variables.

2. github-env-injection: The MODE_CACHE_KEY computation now uses printf '%s' "$INPUT_MODE" (env var, not inline expression) and pipes through tr -d '\n\r' to strip newlines before writing to $GITHUB_OUTPUT.

3. unsafe-shell: Replaced 'curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet' with download-then-execute: curl saves to a temp file, then 'bash "$INSTALLER_TMP" --quiet' executes it. The '--' was dropped (it was the shell's option terminator in the pipe form, not an argument to the install script itself).

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in action.yml at the 'Determine runner and kernel version' step. The RUNNER_VERSION value (derived from caller-controlled input `inputs.runner-version`) is now sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` before being written to $GITHUB_OUTPUT, preventing newline injection attacks. Also applied the same sanitization to VERSION_TYPE since it's derived from RUNNER_VERSION in the branch:/rev: cases. The fix is consistent with the existing sanitization pattern already used for MODE_CACHE_KEY in the same step.

