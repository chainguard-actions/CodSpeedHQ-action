<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.6** was hardened automatically. 27 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate `${{ ... }}` expressions (rule a) inside shell commands. YAML template substitution occurs before the shell parses the string, so an attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can break out of the intended command context.

**Step "Determine runner and kernel version"** (line 93): `RUNNER_VERSION="${{ inputs.runner-version }}"` and (line 116) `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — both `inputs.runner-version` and `inputs.mode` are interpolated directly into the shell script.

**Step "Install CodSpeed runner"** (line 141): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly in the run block.

**Step "Run the benchmarks"** (line 215 onward): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly inside the shell script. All of these should be passed via `env:` variables and then referenced as quoted shell variables (`"$VAR"`).

Locations:

- `action.yml:93`
- `action.yml:116`
- `action.yml:141`
- `action.yml:215`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two unsanitized values derived from user-controlled inputs are written to `$GITHUB_OUTPUT` without the required `printf '%s' ... | tr -d '\n\r'` sanitization step:

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 113) — `RUNNER_VERSION` is set directly from `${{ inputs.runner-version }}` on line 93. A newline embedded in the input value would allow injection of additional output variables.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 117) — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` on line 116. Same injection risk.

Neither write is preceded by the sanitization pipeline `safe=$(printf '%s' "$VAR" | tr -d '\n\r')`.

Locations:

- `action.yml:113`
- `action.yml:117`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, remote shell scripts are fetched and piped directly to `bash` without first downloading to a file and verifying integrity:

1. (line 152) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when `VERSION_TYPE` is `latest`. The script is executed immediately from the network with no hash verification.

2. (line 158) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when `VERSION_TYPE` is `prerelease`. Same pattern.

A network-level attacker or a compromised CDN could serve a malicious script that would be executed directly on the runner. The safe pattern (used for release versions in the same step) downloads to a temp file and verifies a SHA-256 hash before executing — that same pattern should be applied to all version types.

Locations:

- `action.yml:152`
- `action.yml:158`

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

Rewrote hardened/action/action.yml with three categories of fixes:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps. The 'Determine runner and kernel version' step now has INPUT_RUNNER_VERSION and INPUT_MODE in env:. The 'Install CodSpeed runner' step now has RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH in env:. The 'Run the benchmarks' step now has INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG in env:. All shell scripts reference these as plain $VAR_NAME variables.

2. **github-env-injection**: Sanitized both values written to $GITHUB_OUTPUT that derive from user-controlled inputs: RUNNER_VERSION is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` before writing, and MODE_CACHE_KEY computation now includes `| tr -d '\n\r'` to strip newlines.

3. **unsafe-shell**: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with the safe download-then-execute pattern: `curl -fsSL -o "$INSTALLER_TMP" <url>` followed by `bash "$INSTALLER_TMP" --quiet`, matching the existing safe pattern used for release versions.

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all three findings: (1) script-injection in bump-runner-version.yml by moving `${{ github.event.inputs.version }}` into the step's `env:` block as `INPUT_VERSION` and referencing it as a plain shell variable throughout the run script; (2) pinned all 8 occurrences of `actions/checkout@v4` to full SHA `34e114876b0b11c390a56381ad16ebd13914f8d5 # v4` in both workflow files; (3) added `permissions: contents: read` top-level block to ci.yml to enforce least-privilege token access.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted shell expansions of $VERSION and $BRANCH_NAME in .github/workflows/bump-runner-version.yml. Changed: (1) BRANCH_NAME=bump-runner-version/$VERSION → BRANCH_NAME="bump-runner-version/$VERSION", (2) git checkout -b $BRANCH_NAME → git checkout -b "$BRANCH_NAME", (3) echo $VERSION > .codspeed-runner-version → echo "$VERSION" > .codspeed-runner-version, (4) git push origin $BRANCH_NAME → git push origin "$BRANCH_NAME", and also fixed --head $BRANCH_NAME → --head "$BRANCH_NAME" in the gh pr create command. All expansions of attacker-controlled input are now properly double-quoted.

