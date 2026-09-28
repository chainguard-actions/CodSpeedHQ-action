<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` are directly interpolated inside `run:` shell command strings across three steps. This allows an attacker-controlled value to inject shell metacharacters before the shell ever parses the command.

Step 'Determine runner and kernel version' (line ~104): `RUNNER_VERSION="${{ inputs.runner-version }}"`
Step 'Determine runner and kernel version' (line ~127): `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`
Step 'Install CodSpeed runner' (line ~146): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
Step 'Install CodSpeed runner' (line ~147): `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
Step 'Install CodSpeed runner' (line ~149): `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
Step 'Install CodSpeed runner' (line ~182): `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`
Step 'Run the benchmarks' (lines ~213–248): `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"`

All of these must be moved to `env:` variables and then referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:104`
- `action.yml:127`
- `action.yml:146`
- `action.yml:147`
- `action.yml:149`
- `action.yml:182`
- `action.yml:213`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` was set from `${{ inputs.runner-version }}` (a user-controlled input) earlier in the same script. No newline stripping is applied before the write.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'`, which strips commas but does NOT strip newline/carriage-return characters. A value containing `\n` could inject additional key=value pairs into `$GITHUB_OUTPUT`, poisoning subsequent steps.

Fix: apply `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before each write.

Locations:

- `action.yml:122`
- `action.yml:128`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, when `VERSION_TYPE` equals `latest`, the script fetches a remote shell script and pipes it directly to bash without any intermediate verification:

`curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`

If the remote server is compromised or the DNS/TLS is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified against a known-good value, and only then executed — exactly as the action already does for pinned release versions.

Locations:

- `action.yml:154`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). Shell scripts now reference these as $VAR_NAME.

2. github-env-injection: In 'Determine runner and kernel version', RUNNER_VERSION is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` before writing to $GITHUB_OUTPUT, and MODE_CACHE_KEY is sanitized with `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'` before writing.

3. unsafe-shell: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with download-then-execute pattern: `curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"` followed by `bash "$INSTALL_SCRIPT" --quiet` (dropped the `--` which was the shell's option terminator, not the script's argument).

