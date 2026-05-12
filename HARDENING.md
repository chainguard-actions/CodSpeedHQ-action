# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `inputs.*` expressions are directly interpolated inside `run:` shell blocks without first being assigned to environment variables. In the 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` (line 97) and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line 128). In the 'Install CodSpeed runner' step: `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line 157). In the 'Run the benchmarks' step: `if [ -z "${{ inputs.mode }}" ]` and many other direct interpolations of inputs.token, inputs.working-directory, inputs.upload-url, inputs.mode, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, and inputs.config (lines 221+). An attacker-controlled input value containing shell metacharacters could break out of the intended command context.

Locations:

- `action.yml:97`
- `action.yml:128`
- `action.yml:157`
- `action.yml:221`

### github-env-injection (severity: high)

Attacker-controlled `inputs.*` values are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`). In the 'Determine runner and kernel version' step: `inputs.runner-version` is interpolated into `RUNNER_VERSION` and written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 120), and `inputs.mode` is interpolated into `MODE_CACHE_KEY` and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 129). A newline injected into these inputs could add arbitrary key=value pairs to the GitHub environment output, enabling environment variable injection into subsequent steps.

Locations:

- `action.yml:120`
- `action.yml:129`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote URL is compromised or subject to a MITM attack, arbitrary code will be executed on the runner without any integrity check. This pattern only applies to the 'latest' version path — the release version path correctly downloads to a temp file and verifies a SHA256 hash before executing.

Locations:

- `action.yml:163`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} expressions from run: shell blocks into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.) instead of template expressions.

2. github-env-injection: Added newline sanitization (printf '%s' "$VAR" | tr -d '\n\r') before writing runner-version and mode-cache-key to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step.

3. unsafe-shell: Replaced the 'curl | bash' pattern for the 'latest' version path with a two-step approach: download the installer to a temp file first, then execute it separately. This prevents MITM attacks from executing arbitrary code directly.

