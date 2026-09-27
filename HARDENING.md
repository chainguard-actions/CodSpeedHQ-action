<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.2** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` are directly interpolated inside `run:` shell command strings across three steps, violating rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can protect it.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Step 4 ('Run the benchmarks'): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly in the shell script.

Fix: move all `${{ ... }}` values into `env:` variables and reference them as quoted shell variables (e.g. `"$VAR"`) inside the `run:` block.

Locations:

- `action.yml:96`
- `action.yml:117`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:185`
- `action.yml:222`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`
- `action.yml:243`
- `action.yml:246`
- `action.yml:249`
- `action.yml:252`
- `action.yml:255`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `RUNNER_VERSION` is populated from `${{ inputs.runner-version }}` (untrusted input) and then written to `$GITHUB_OUTPUT` via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without the required sanitization step (`printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'`). Similarly, `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written to `$GITHUB_OUTPUT` via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline character in either input could inject arbitrary key=value pairs into the GitHub output environment.

Locations:

- `action.yml:113`
- `action.yml:118`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote shell scripts directly to `bash` without first downloading and verifying them:
1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used for the 'latest' version path — no hash verification)
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for the 'prerelease' version path — no hash verification)

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as is already done for the release version path in the same step).

Locations:

- `action.yml:157`
- `action.yml:165`

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

1. **script-injection / static-inline-injection** (all steps): Moved all `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions from `run:` blocks into `env:` blocks. Step 1 ('Determine runner and kernel version') now uses `INPUT_RUNNER_VERSION` and `INPUT_MODE`. Step 3 ('Install CodSpeed runner') now uses `RUNNER_VERSION`, `VERSION_TYPE`, `SKIP_HASH_CHECK_WARNING`, and `EXPECTED_HASH` env vars. Step 4 ('Run the benchmarks') now uses `INPUT_MODE`, `INPUT_TOKEN`, `INPUT_WORKING_DIRECTORY`, `INPUT_UPLOAD_URL`, `INPUT_INSTRUMENTS`, `INPUT_MONGO_URI_ENV_NAME`, `INPUT_CACHE_INSTRUMENTS`, `INPUT_INSTRUMENTS_CACHE_DIR`, `INPUT_ALLOW_EMPTY`, `INPUT_GO_RUNNER_VERSION`, and `INPUT_CONFIG` env vars.

2. **github-env-injection**: All values written to `$GITHUB_OUTPUT` in the 'Determine runner and kernel version' step are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing.

3. **unsafe-shell**: Both `curl | bash` patterns (for 'latest' and 'prerelease' version paths) replaced with download-to-tempfile-then-execute patterns. The `--` shell option terminator was correctly dropped when converting from pipe form to file execution.

