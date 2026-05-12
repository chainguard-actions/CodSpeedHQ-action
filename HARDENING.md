# Hardening Report: CodSpeedHQ--action/v4.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.13.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are directly interpolated inside the `run:` shell block without first being assigned to environment variables. An attacker who controls these inputs can inject arbitrary shell commands.

Locations:

- `action.yml:100`
- `action.yml:138`

### script-injection (severity: high)

In the 'Install CodSpeed runner' step, `${{ inputs.skip-hash-check-warning }}` is directly interpolated inside the `run:` shell block without first being assigned to an environment variable. An attacker who controls this input can inject arbitrary shell commands.

Locations:

- `action.yml:175`

### script-injection (severity: high)

In the 'Run the benchmarks' step, multiple inputs are directly interpolated inside the `run:` shell block: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. These should be passed via env: variables instead.

Locations:

- `action.yml:248`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the variable RUNNER_VERSION (derived from `${{ inputs.runner-version }}`) and MODE_CACHE_KEY (derived from `${{ inputs.mode }}`) are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline injected via these inputs could add arbitrary entries to GITHUB_OUTPUT.

Locations:

- `action.yml:128`
- `action.yml:134`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes a remote script directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever the remote server returns without any integrity check, enabling supply-chain attacks if the URL is compromised.

Locations:

- `action.yml:185`

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

Fixed all security findings in actions/hardened/CodSpeedHQ--action/v4.13.0/action.yml:

1. **script-injection / static-inline-injection** in 'Determine runner and kernel version': Moved `${{ inputs.runner-version }}` and `${{ inputs.mode }}` to an `env:` block as `INPUT_RUNNER_VERSION` and `INPUT_MODE`, then referenced them as plain shell variables.

2. **github-env-injection** in 'Determine runner and kernel version': All values written to `$GITHUB_OUTPUT` are now sanitized using `printf '%s' "$VAR" | tr -d '\n\r'` before writing.

3. **script-injection / static-inline-injection** in 'Install CodSpeed runner': Moved `${{ inputs.skip-hash-check-warning }}` to an `env:` block as `INPUT_SKIP_HASH_CHECK_WARNING`.

4. **unsafe-shell** in 'Install CodSpeed runner': Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a download-then-execute pattern: download to a temp file with `curl -fsSL -o "$INSTALL_TMP"`, then execute with `bash "$INSTALL_TMP" --quiet`.

5. **script-injection / static-inline-injection** in 'Run the benchmarks': Moved all 11 inputs (`mode`, `token`, `working-directory`, `upload-url`, `instruments`, `mongo-uri-env-name`, `cache-instruments`, `instruments-cache-dir`, `allow-empty`, `go-runner-version`, `config`) to the `env:` block and replaced all inline `${{ inputs.* }}` references in the shell script with plain environment variable references.

