<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell blocks, violating rule (a). This allows template substitution to inject arbitrary shell syntax before the shell parses the command.

Step 'Determine runner and kernel version' (line 97): `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input interpolated directly into shell.
Step 'Determine runner and kernel version' (line 130): `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input interpolated directly into shell.
Step 'Install CodSpeed runner' (line 156): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` — step output interpolated directly into shell.
Step 'Install CodSpeed runner' (line 157): `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` — step output interpolated directly into shell.
Step 'Install CodSpeed runner' (line 159): `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` — attacker-controlled input interpolated directly into shell.
Step 'Install CodSpeed runner' (~line 185): `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — step output interpolated directly into shell.
Step 'Run the benchmarks' (~line 209 onward): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}` are all interpolated directly into the run: shell script. All inputs should be passed via env: variables and then referenced as quoted shell variables (e.g., `"$VAR"`) instead.

Locations:

- `action.yml:97`
- `action.yml:130`
- `action.yml:156`
- `action.yml:157`
- `action.yml:159`
- `action.yml:185`
- `action.yml:209`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the value of `${{ inputs.mode }}` (an attacker-controlled input) is interpolated directly into a shell variable `MODE_CACHE_KEY` via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`, and then written to `$GITHUB_OUTPUT` with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transformation only strips commas — it does NOT strip newline (`\n`) or carriage-return (`\r`) characters, which are the characters that allow injection into the GITHUB_OUTPUT format. The required sanitization step `printf '%s' "$MODE_CACHE_KEY" | tr -d '\n\r'` is absent before the write.

Locations:

- `action.yml:130`
- `action.yml:131`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote installer scripts directly to bash without first downloading to a file and verifying integrity:
1. Line 165: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used for the 'latest' version path. The script is fetched from a remote URL and piped directly to bash, meaning a compromised or MITM'd response executes immediately with no hash verification.
2. Line 171: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used for the 'prerelease' version path. Same issue. Note that the release version path correctly downloads to a temp file and verifies a SHA256 hash before executing, but the 'latest' and 'prerelease' paths bypass this protection entirely.

Locations:

- `action.yml:165`
- `action.yml:171`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all findings in action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $RUNNER_VERSION, etc.

2. github-env-injection: Changed MODE_CACHE_KEY computation from `echo "${{ inputs.mode }}" | tr ',' '-'` to `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'` to sanitize newlines/carriage-returns before writing to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed both curl|bash patterns for 'latest' and 'prerelease' version paths. Each now downloads to a temp file first (`curl -fsSL ... -o "$INSTALL_SCRIPT"`) then executes separately (`bash "$INSTALL_SCRIPT" --quiet`). The '--' was dropped as it was the shell's option terminator in the pipe form, not an argument to the installer script.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in action.yml at the 'Determine runner and kernel version' step. Added sanitization for RUNNER_VERSION before writing to $GITHUB_OUTPUT using `SAFE_RUNNER_VERSION=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')`. Also sanitized VERSION_TYPE for consistency. This matches the pattern already used for mode-cache-key in the same step.

