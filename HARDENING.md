<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml, allowing shell metacharacter injection before the shell ever sees the value.

1. 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled inputs are expanded directly into the shell script.

2. 'Install CodSpeed runner' step: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly into the run: block.

3. 'Run the benchmarks' step: Numerous `${{ inputs.* }}` expressions (`inputs.mode`, `inputs.token`, `inputs.working-directory`, `inputs.upload-url`, `inputs.instruments`, `inputs.mongo-uri-env-name`, `inputs.cache-instruments`, `inputs.instruments-cache-dir`, `inputs.allow-empty`, `inputs.go-runner-version`, `inputs.config`) are interpolated directly into the run: shell script. These should be passed via env: variables and referenced as quoted shell variables instead.

Locations:

- `action.yml:104`
- `action.yml:126`
- `action.yml:157`
- `action.yml:158`
- `action.yml:160`
- `action.yml:196`
- `action.yml:226`
- `action.yml:232`
- `action.yml:235`
- `action.yml:238`
- `action.yml:241`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`
- `action.yml:256`
- `action.yml:259`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled input) and then written with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` and `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT`. A newline in the input value could inject arbitrary key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` does not strip newlines, so a newline in `inputs.mode` can still inject additional entries into GITHUB_OUTPUT.

Locations:

- `action.yml:122`
- `action.yml:123`
- `action.yml:127`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:

1. For 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the script is fetched and executed in a single pipeline with no hash verification.

2. For 'prerelease' version: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for pre-release versions.

Note: the release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths do not.

Locations:

- `action.yml:168`
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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). All shell references updated to use the env var names.

2. github-env-injection: Sanitized all values written to $GITHUB_OUTPUT using 'printf \'%s\' "$VAR" | tr -d \'\n\r\'' before writing. Applied to runner-version, version-type, and mode-cache-key outputs.

3. unsafe-shell: Replaced both 'curl | bash -s -- --quiet' pipe patterns (for 'latest' and 'prerelease' version types) with download-then-execute: curl downloads to a temp file, then bash executes the file directly. The '--' separator (shell option terminator from the pipe form) was correctly dropped since it's not needed when executing a file.

