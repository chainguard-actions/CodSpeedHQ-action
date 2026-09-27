<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.2** was hardened automatically. 34 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ inputs.* }}` expressions are interpolated directly inside `run:` shell command strings in the 'Determine runner and kernel version' step. Specifically: `RUNNER_VERSION="${{ inputs.runner-version }}"` (line 109) and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line 142). An attacker-controlled input value is substituted directly into the shell script before the shell parses it, enabling command injection.

Locations:

- `action.yml:109`
- `action.yml:142`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside the `run:` shell script of the 'Install CodSpeed runner' step. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line 168), `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line 169), and `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line 171). These values flow through YAML template substitution before the shell parses them.

Locations:

- `action.yml:168`
- `action.yml:169`
- `action.yml:171`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' step interpolates numerous `${{ inputs.* }}` expressions directly inside the `run:` shell script, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, and `${{ inputs.exclude-allocations }}`. Any of these caller-supplied values can contain shell metacharacters that execute arbitrary commands.

Locations:

- `action.yml:225`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the variable `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an untrusted input) and then written to `$GITHUB_OUTPUT` via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` and `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`). A newline-containing input value can inject arbitrary key-value pairs into the output context.

Locations:

- `action.yml:134`
- `action.yml:135`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (an untrusted input) and written to `$GITHUB_OUTPUT` via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline in `inputs.mode` can inject arbitrary entries into the GitHub output context.

Locations:

- `action.yml:143`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for prerelease versions. If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner without any integrity check.

Locations:

- `action.yml:177`
- `action.yml:183`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:110`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:143`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:172`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:276`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: shell blocks and into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables.

2. **github-env-injection**: All values written to $GITHUB_OUTPUT (runner-version, version-type, kernel-version, mode-cache-key) are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing, preventing newline injection.

3. **unsafe-shell**: Replaced both `curl -fsSL ... | bash -s -- --quiet` patterns with a download-to-tempfile-then-execute pattern. The `--` was correctly dropped (it was the shell's option terminator, not the script's argument). The `--quiet` flag is passed directly to the downloaded script.

4. The EXPECTED_HASH variable (previously inline `${{ steps.installer-hash.outputs.hash }}`) was also moved to the env: block of the 'Install CodSpeed runner' step.

