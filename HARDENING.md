<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.6** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ inputs.* }} expressions are directly interpolated inside run: shell command strings in action.yml, violating rule (a). In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly into shell. In the 'Run the benchmarks' step, virtually every input is interpolated directly: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. An attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can achieve arbitrary command execution. All inputs should be passed via env: variables and then referenced as double-quoted shell variables.

Locations:

- `action.yml:100`
- `action.yml:143`
- `action.yml:196`
- `action.yml:200`
- `action.yml:203`
- `action.yml:206`
- `action.yml:209`
- `action.yml:212`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization. (1) `$RUNNER_VERSION` (sourced from `${{ inputs.runner-version }}`) is written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without first stripping newlines. (2) `$MODE_CACHE_KEY` (derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`) is written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A value containing a newline character can inject arbitrary key=value pairs into GITHUB_OUTPUT, potentially overwriting outputs consumed by later steps. The fix is to apply `printf '%s' "$VAR" | tr -d '\n\r'` before each write.

Locations:

- `action.yml:131`
- `action.yml:136`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote shell scripts directly to bash in two places: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version type, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for prerelease versions. Piping remote content directly to a shell interpreter without first downloading and verifying the script is a supply-chain risk — a compromised or MITM'd response executes immediately with no opportunity for inspection or integrity verification. The script should be downloaded to a temporary file, its hash verified, and then executed separately (as is already done for release versions in the same step).

Locations:

- `action.yml:162`
- `action.yml:170`

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

1. script-injection/static-inline-injection: Moved all ${{ inputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': runner-version and mode inputs moved to env: as INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': skip-hash-check-warning moved to env: as INPUT_SKIP_HASH_CHECK_WARNING
   - 'Run the benchmarks': All 11 inputs (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) moved to env: block

2. github-env-injection: Sanitized both values written to $GITHUB_OUTPUT using printf '%s' | tr -d '\n\r' to strip newlines before writing runner-version and mode-cache-key outputs.

3. unsafe-shell: Replaced both curl | bash patterns with download-to-tempfile-then-execute patterns. For 'latest' and 'prerelease' version types, the script is now downloaded to a mktemp file and executed with 'bash script --quiet' (dropping the '--' separator that was only needed for the pipe form's shell option parsing).

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed all three script injection issues in the 'Install CodSpeed runner' step of action.yml. Moved `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, and `${{ steps.installer-hash.outputs.hash }}` from inline run: shell assignments into the step's env: block. The shell script now references these as plain environment variables ($RUNNER_VERSION, $VERSION_TYPE, $EXPECTED_HASH), preventing template-level injection of attacker-controlled values.

