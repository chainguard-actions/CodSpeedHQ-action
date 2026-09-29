<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple GitHub Actions expressions (${{ ... }}) are directly interpolated inside run: shell command strings in action.yml.

Step 1 ('Determine runner and kernel version'):
  - `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input injected directly into shell
  - `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input injected directly into shell

Step 3 ('Install CodSpeed runner'):
  - `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
  - `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
  - `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
  - `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

Step 4 ('Run the benchmarks'):
  - `if [ -z "${{ inputs.mode }}" ]`
  - `if [ -n "${{ inputs.token }}" ]` / `--token "${{ inputs.token }}"`
  - `--working-directory="${{ inputs.working-directory }}"`
  - `--upload-url="${{ inputs.upload-url }}"`
  - `--mode="${{ inputs.mode }}"`
  - `--instruments="${{ inputs.instruments }}"`
  - `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
  - `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
  - `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`
  - `if [ "${{ inputs.allow-empty }}" = "true" ]`
  - `--go-runner-version="${{ inputs.go-runner-version }}"`
  - `--config="${{ inputs.config }}"`

All these expressions are substituted by the Actions runner before the shell ever sees the string, allowing an attacker who controls any of these inputs to inject arbitrary shell commands.

Locations:

- `action.yml:101`
- `action.yml:122`
- `action.yml:145`
- `action.yml:146`
- `action.yml:148`
- `action.yml:175`
- `action.yml:210`
- `action.yml:215`
- `action.yml:219`
- `action.yml:223`
- `action.yml:227`
- `action.yml:231`
- `action.yml:235`
- `action.yml:239`
- `action.yml:243`
- `action.yml:247`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r').

1. `$RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 101) and then written unsanitized:
   `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`
   `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT`
   (VERSION_TYPE is also derived from RUNNER_VERSION via string matching)

2. `$MODE_CACHE_KEY` is set from `${{ inputs.mode }}` (line 122) and then written unsanitized:
   `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`

An attacker who controls `inputs.runner-version` or `inputs.mode` can inject newlines into these values to poison subsequent steps that read from $GITHUB_OUTPUT.

Locations:

- `action.yml:119`
- `action.yml:120`
- `action.yml:125`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, remote content is fetched and piped directly to bash without first saving to a file and verifying integrity:

  `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`

This pattern executes whatever the remote server returns, making the action vulnerable to supply-chain attacks if the remote URL is compromised or returns malicious content. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' version path bypasses this protection entirely.

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

Fixed all findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': moved inputs.runner-version → INPUT_RUNNER_VERSION, inputs.mode → INPUT_MODE
   - 'Install CodSpeed runner': moved steps.versions.outputs.runner-version → RUNNER_VERSION, steps.versions.outputs.version-type → VERSION_TYPE, inputs.skip-hash-check-warning → SKIP_HASH_CHECK_WARNING, steps.installer-hash.outputs.hash → EXPECTED_HASH
   - 'Run the benchmarks': moved all 11 inputs to env: (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG)

2. github-env-injection: Sanitized RUNNER_VERSION, VERSION_TYPE, and MODE_CACHE_KEY before writing to $GITHUB_OUTPUT using printf '%s' "$VAR" | tr -d '\n\r'. Also quoted $GITHUB_OUTPUT references.

3. unsafe-shell: Replaced 'curl ... | bash -s -- --quiet' with downloading to a temp file first (curl -fsSL ... -o "$LATEST_INSTALLER_TMP") then executing separately (bash "$LATEST_INSTALLER_TMP" --quiet), dropping the '--' which was the shell's option terminator.

