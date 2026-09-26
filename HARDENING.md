<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings across three steps in action.yml, violating sub-rule (a).

**Step 1 — "Determine runner and kernel version":**
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input injected directly into shell.
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input injected directly into shell.

**Step 2 — "Install CodSpeed runner":**
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step 3 — "Run the benchmarks":**
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

All these values should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR") rather than being interpolated directly.

Locations:

- `action.yml:95`
- `action.yml:117`
- `action.yml:134`
- `action.yml:135`
- `action.yml:137`
- `action.yml:163`
- `action.yml:191`
- `action.yml:196`
- `action.yml:199`
- `action.yml:203`
- `action.yml:207`
- `action.yml:210`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (direct expression interpolation) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. An attacker can inject newlines to poison subsequent GITHUB_OUTPUT entries.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which only strips commas, not newlines/carriage-returns) and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transformation does not constitute the required sanitization (`tr -d '\n\r'`).

Both writes must be preceded by `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before writing to $GITHUB_OUTPUT.

Locations:

- `action.yml:112`
- `action.yml:113`
- `action.yml:117`
- `action.yml:118`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes a remote script directly to bash without first downloading and verifying it: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This is executed when `VERSION_TYPE` equals `"latest"`. A compromised or MITM'd response from codspeed.io would execute arbitrary code on the runner. The release-version path (which downloads to a temp file and verifies a SHA-256 hash) is the correct pattern and should be used for all installation paths, or the latest-version path should be removed.

Locations:

- `action.yml:143`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks across all three affected steps ("Determine runner and kernel version", "Install CodSpeed runner", "Run the benchmarks"). Shell scripts now reference these as plain environment variables.

2. **github-env-injection**: In the "Determine runner and kernel version" step, RUNNER_VERSION and MODE_CACHE_KEY are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being written to $GITHUB_OUTPUT.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a safe download-then-execute pattern: downloads to a temp file first, then executes `bash "$LATEST_INSTALLER_TMP" --quiet` (dropping the `--` which was the shell's option terminator, not the script's argument).

