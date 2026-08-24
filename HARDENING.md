<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.0** was hardened automatically. 31 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate `${{ ... }}` expressions inside shell commands, violating rule (a). This allows an attacker who controls the inputs (e.g. via a calling workflow) to inject arbitrary shell commands.

**Step: "Determine runner and kernel version"** — `${{ inputs.runner-version }}`, `${{ runner.os }}`, and `${{ inputs.mode }}` are interpolated directly into shell variable assignments and command substitutions:
  - `RUNNER_VERSION="${{ inputs.runner-version }}"`
  - `DISTRO="${{ runner.os }}"`
  - `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

**Step: "Install CodSpeed runner"** — `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, and `${{ inputs.skip-hash-check-warning }}` are interpolated directly into shell variable assignments:
  - `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
  - `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
  - `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`

**Step: "Run the benchmarks"** — Thirteen `inputs.*` expressions are interpolated directly into shell conditionals and array assignments, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, and `${{ inputs.exclude-allocations }}`.

All of these should be moved to `env:` variables and referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:100`
- `action.yml:119`
- `action.yml:124`
- `action.yml:168`
- `action.yml:169`
- `action.yml:171`
- `action.yml:196`
- `action.yml:207`
- `action.yml:211`
- `action.yml:215`
- `action.yml:219`
- `action.yml:223`
- `action.yml:227`
- `action.yml:231`
- `action.yml:235`
- `action.yml:239`
- `action.yml:243`
- `action.yml:247`
- `action.yml:251`

### github-env-injection (severity: high)

The "Determine runner and kernel version" `run:` block writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (attacker-controlled) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input value could inject additional output variables.
2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'` and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — the `tr` only replaces commas, not newlines/carriage-returns.

Fix: apply `printf '%s' "$VAR" | tr -d '\n\r'` before each write to `$GITHUB_OUTPUT`.

Locations:

- `action.yml:108`
- `action.yml:109`
- `action.yml:113`
- `action.yml:120`
- `action.yml:125`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" `run:` block pipes remote shell scripts directly to `bash` without first downloading and verifying them:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used for the `latest` version path; no hash verification.
2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used for the `prerelease` version path; no hash verification.

If the remote server or network is compromised, arbitrary code executes on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the `latest` and `prerelease` paths.

Locations:

- `action.yml:183`
- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:110`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:153`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:182`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }}, ${{ steps.*.outputs.* }}, and ${{ runner.os }} expressions from run: blocks into env: maps. Three steps were affected: 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, RUNNER_OS, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (13 INPUT_* variables). Shell scripts now reference plain env vars.

2. **github-env-injection**: Added printf '%s' "$VAR" | tr -d '\n\r' sanitization before all writes to $GITHUB_OUTPUT: runner-version (safe_runner_version), distro (safe_distro), and mode-cache-key (piped through tr -d '\n\r' after comma replacement).

3. **unsafe-shell**: Replaced both curl | bash patterns (for 'latest' and 'prerelease' version paths) with the safe download-then-execute pattern: curl -fsSL ... -o "$INSTALLER_TMP" followed by bash "$INSTALLER_TMP" --quiet. The '--' shell option terminator from the original 'bash -s --' form was correctly dropped since we're no longer reading from stdin.

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

1. Fixed script-injection in .github/workflows/bump-runner-version.yml: moved `${{ github.event.inputs.version }}` into an env var `INPUT_VERSION` and replaced all 4 inline template expressions with `$INPUT_VERSION` shell references. Also quoted `v$INPUT_VERSION` properly as `"v$INPUT_VERSION"`. 2. Fixed unpinned-uses: pinned all 9 occurrences of `actions/checkout@v4` (1 in bump-runner-version.yml, 8 in ci.yml) to the full commit SHA `actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4`.

