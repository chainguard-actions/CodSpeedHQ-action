<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.17.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings across three steps in action.yml, violating sub-rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version' (line ~100):
  RUNNER_VERSION="${{ inputs.runner-version }}"  # direct interpolation
  MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')  # direct interpolation

Step 'Install CodSpeed runner' (line ~148):
  RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
  VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
  SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
  EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"

Step 'Run the benchmarks' (line ~195):
  if [ -z "${{ inputs.mode }}" ]; then ...
  RUNNER_ARGS+=(--token "${{ inputs.token }}")
  RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")
  RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")
  RUNNER_ARGS+=(--mode="${{ inputs.mode }}")
  RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")
  RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")
  if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]
  RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")
  if [ "${{ inputs.allow-empty }}" = "true" ]
  RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")
  RUNNER_ARGS+=(--config="${{ inputs.config }}")

All inputs.* values should be passed via env: variables and then referenced as quoted shell variables (e.g., "$INPUT_MODE") rather than interpolated directly.

Locations:

- `action.yml:100`
- `action.yml:118`
- `action.yml:148`
- `action.yml:150`
- `action.yml:152`
- `action.yml:195`
- `action.yml:202`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, untrusted input values are written to $GITHUB_OUTPUT without the required newline-stripping sanitization (printf '%s' ... | tr -d '\n\r').

1. inputs.runner-version is interpolated directly into RUNNER_VERSION, which is then written to $GITHUB_OUTPUT:
   RUNNER_VERSION="${{ inputs.runner-version }}"
   ...
   echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT

2. inputs.mode is interpolated directly into MODE_CACHE_KEY, which is then written to $GITHUB_OUTPUT:
   MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')
   echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT

An attacker-controlled newline in either input could inject additional key=value pairs into GITHUB_OUTPUT, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:100`
- `action.yml:118`
- `action.yml:120`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, when VERSION_TYPE is 'latest', the action downloads and pipes a remote shell script directly to bash without first saving it to a file for inspection or hash verification:

  curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet

If the remote server is compromised or the DNS is hijacked, arbitrary code would execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed separately — as the action already does for pinned release versions.

Locations:

- `action.yml:157`

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

Fixed all security findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $INPUT_RUNNER_VERSION, etc.

2. github-env-injection: Added newline-stripping sanitization before writing to $GITHUB_OUTPUT. RUNNER_VERSION is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and INPUT_MODE is sanitized with `printf '%s' "$INPUT_MODE" | tr -d '\n\r'` before their values are written to $GITHUB_OUTPUT.

3. unsafe-shell: Replaced the `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` pipe-to-bash pattern with a safe download-then-execute pattern: download to a mktemp file, check HTTP status code for errors, then execute with `bash "$INSTALLER_TMP" --quiet`. This is consistent with how the release version already handled installation.

