<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.4.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.4.0** was hardened automatically. 34 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings across three composite action steps, violating rule (a).

**Step 1 — "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` embed user-controlled inputs directly into shell.

**Step 2 — "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, and `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` are all interpolated directly into the shell script.

**Step 3 — "Run the benchmarks"**: Over a dozen `${{ inputs.* }}` expressions (e.g. `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}`, `${{ inputs.simulation-track-subprocess }}`, `${{ inputs.disable-memory-track-physical }}`, `${{ inputs.disable-memory-capture-stack }}`) are interpolated directly into shell commands. An attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can achieve arbitrary command execution. All these values must be routed through `env:` variables and then double-quoted in the shell.

Locations:

- `action.yml:125`
- `action.yml:155`
- `action.yml:168`
- `action.yml:175`
- `action.yml:178`
- `action.yml:222`
- `action.yml:232`
- `action.yml:237`
- `action.yml:241`
- `action.yml:245`
- `action.yml:249`
- `action.yml:253`
- `action.yml:256`
- `action.yml:260`
- `action.yml:263`
- `action.yml:267`
- `action.yml:270`
- `action.yml:274`
- `action.yml:278`
- `action.yml:282`
- `action.yml:286`
- `action.yml:290`

### github-env-injection (severity: high)

The "Determine runner and kernel version" step writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without sanitization.

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `$RUNNER_VERSION` is set directly from `${{ inputs.runner-version }}` (an attacker-controlled value). A newline embedded in the input can inject arbitrary key=value pairs into `$GITHUB_OUTPUT`.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `$MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`. The `tr` call only strips commas, not newlines; a newline in `inputs.mode` still reaches `$GITHUB_OUTPUT`.

The required sanitization (`printf '%s' "$VAR" | tr -d '\n\r'`) must be applied immediately before each write.

Locations:

- `action.yml:140`
- `action.yml:155`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to `bash` in two code paths, without first downloading to a file and verifying integrity:

1. **`latest` path**: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the script is fetched from a mutable URL and executed immediately. A compromised or MITM'd response executes arbitrary code.

2. **`prerelease` path**: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern with a version-parameterised URL. Note that the `release` path correctly downloads to a temp file and verifies a SHA-256 hash before executing; the `latest` and `prerelease` paths should follow the same pattern.

Locations:

- `action.yml:183`
- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:135`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:178`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:285`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:288`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:294`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:297`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:300`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:304`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:306`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:309`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:310`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:312`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:313`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:315`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:316`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:318`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:319`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:321`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.disable-memory-track-physical }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:325`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.disable-memory-capture-stack }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:328`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks across all three affected steps (Determine runner and kernel version, Install CodSpeed runner, Run the benchmarks). Shell scripts now reference values via $INPUT_* environment variables.

2. **github-env-injection**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before every write to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step (runner-version, version-type, kernel-version, distro, mode-cache-key).

3. **unsafe-shell**: Fixed two curl|bash patterns in 'Install CodSpeed runner':
   - `latest` path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` → download to temp file, then `bash "$INSTALLER_TMP" --quiet`
   - `prerelease` path: same fix applied
   - The `--` was correctly dropped (it was the shell's stdin-mode option terminator, not a script argument)

4. Also moved ${{ steps.installer-hash.outputs.hash }} and ${{ runner.os }} from inline run: usage to env: blocks.

