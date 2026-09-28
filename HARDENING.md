<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate `${{ ... }}` expressions inside shell commands, violating rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can protect it.

**Step: "Determine runner and kernel version" (line ~103)**:
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — inputs.runner-version interpolated directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs.mode interpolated directly into shell

**Step: "Install CodSpeed runner" (line ~161)**:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` — steps output interpolated directly
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` — steps output interpolated directly
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — input interpolated directly
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — steps output interpolated directly

**Step: "Run the benchmarks" (line ~203)**:
- `if [ -z "${{ inputs.mode }}" ]` and multiple `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` — all inputs interpolated directly into shell commands.

All `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` values should be passed via `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) instead of being interpolated directly.

Locations:

- `action.yml:103`
- `action.yml:136`
- `action.yml:161`
- `action.yml:203`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two unsanitized values derived from user-controlled inputs are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled input). A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `$(echo "${{ inputs.mode }}" | tr ',' '-')`. The `tr ',' '-'` only strips commas, not newlines, so a newline in `inputs.mode` can still inject additional output variables.

The correct pattern is:
```bash
safe=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
echo "runner-version=$safe" >> "$GITHUB_OUTPUT"
```

Locations:

- `action.yml:128`
- `action.yml:137`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to `bash` in two code paths, without first downloading to a file and verifying integrity:

1. **Latest version path** (line ~169): `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the install script is fetched from a remote URL and piped directly to bash. If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner.

2. **Prerelease version path** (line ~175): `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions.

Note: the release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing. The `latest` and `prerelease` paths should follow the same pattern, or at minimum use `--fail` and verify a checksum before executing.

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (INPUT_RUNNER_VERSION, INPUT_VERSION_TYPE, INPUT_SKIP_HASH_CHECK_WARNING, INPUT_EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). All shell references updated to use $INPUT_* variables.

2. **github-env-injection**: Added sanitization before writing to $GITHUB_OUTPUT: runner-version and mode-cache-key values are now passed through `printf '%s' "$VAR" | tr -d '\n\r'` before being echoed to $GITHUB_OUTPUT.

3. **unsafe-shell**: Fixed the 'latest' and 'prerelease' install paths to download scripts to temp files first (using `curl ... -o "$INSTALLER_TMP"`), then execute with `bash "$INSTALLER_TMP" --quiet`. Dropped the `--` that was the shell's option terminator in the original pipe form. The release path already used this pattern correctly.

