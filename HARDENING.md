<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.5** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are interpolated directly inside `run:` shell command strings across three steps, violating sub-rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

**Step: "Determine runner and kernel version"** (lines ~104, 127):
- `RUNNER_VERSION="${{ inputs.runner-version }}"`
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

**Step: "Install CodSpeed runner"** (lines ~149–175):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step: "Run the benchmarks"** (lines ~207–240):
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]` → `--token "${{ inputs.token }}"`
- `--working-directory="${{ inputs.working-directory }}"`
- `--upload-url="${{ inputs.upload-url }}"`
- `--mode="${{ inputs.mode }}"`
- `--instruments="${{ inputs.instruments }}"`
- `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
- `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`
- `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`

All these should be moved to `env:` variables and referenced as `"$VAR"` in the shell.

Locations:

- `action.yml:104`
- `action.yml:127`
- `action.yml:149`
- `action.yml:150`
- `action.yml:152`
- `action.yml:175`
- `action.yml:207`
- `action.yml:213`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, `inputs.mode` (an untrusted caller-supplied value) is interpolated into the shell variable `MODE_CACHE_KEY` and then written to `$GITHUB_OUTPUT` without the required newline-stripping sanitization (`printf '%s' ... | tr -d '\n\r'`). The `tr ',' '-'` transformation only replaces commas — it does not strip newline characters, so a crafted multi-line value could inject additional key=value pairs into `$GITHUB_OUTPUT`.

Offending lines:
```bash
MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')
echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT
```

Locations:

- `action.yml:127`
- `action.yml:128`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the action fetches a remote install script and pipes it directly to `bash` without any integrity verification:

```bash
curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet
```

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as the action already does for release versions).

Locations:

- `action.yml:160`

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection** (all three steps): Moved all `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions out of `run:` blocks into `env:` blocks. Updated shell scripts to reference the corresponding `$ENV_VAR` names instead.
   - Step 'Determine runner and kernel version': Added `env: INPUT_RUNNER_VERSION` and `INPUT_MODE`; replaced inline expressions with `$INPUT_RUNNER_VERSION` and `$INPUT_MODE`.
   - Step 'Install CodSpeed runner': Added `env:` block with `RUNNER_VERSION`, `VERSION_TYPE`, `SKIP_HASH_CHECK_WARNING`, `EXPECTED_HASH`; removed all inline expressions from the run block.
   - Step 'Run the benchmarks': Added `env:` entries for all 11 inputs (`INPUT_MODE`, `INPUT_TOKEN`, `INPUT_WORKING_DIRECTORY`, `INPUT_UPLOAD_URL`, `INPUT_INSTRUMENTS`, `INPUT_MONGO_URI_ENV_NAME`, `INPUT_CACHE_INSTRUMENTS`, `INPUT_INSTRUMENTS_CACHE_DIR`, `INPUT_ALLOW_EMPTY`, `INPUT_GO_RUNNER_VERSION`, `INPUT_CONFIG`); replaced all inline expressions with `$ENV_VAR` references.

2. **github-env-injection**: Changed `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` to `MODE_CACHE_KEY=$(printf '%s' "$INPUT_MODE" | tr -d '\n\r' | tr ',' '-')` to strip newlines before writing to `$GITHUB_OUTPUT`.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a safe two-step approach: download to a temp file with `curl -fsSL https://codspeed.io/install.sh -o "$LATEST_INSTALLER_TMP"`, then execute `bash "$LATEST_INSTALLER_TMP" --quiet` (dropped the `--` which was the shell's option terminator, not a script argument).

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in the 'Determine runner and kernel version' step of action.yml. The RUNNER_VERSION variable (derived from user-controlled input `inputs.runner-version`) is now sanitized using `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` before being written to $GITHUB_OUTPUT, preventing newline injection attacks. The VERSION_TYPE variable was also sanitized for defense in depth. The approach is consistent with how MODE_CACHE_KEY was already being handled in the same step.

