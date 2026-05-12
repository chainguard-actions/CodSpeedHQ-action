# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version': The expressions `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly inside the `run:` shell script without first being assigned to environment variables. An attacker-controlled value containing shell metacharacters (e.g. `$(cmd)`, backticks, newlines) could execute arbitrary commands.

Locations:

- `action.yml:93`
- `action.yml:113`

### script-injection (severity: high)

Step 'Install CodSpeed runner': The expression `${{ inputs.skip-hash-check-warning }}` is interpolated directly inside the `run:` shell script without first being assigned to an environment variable. An attacker-controlled value could inject shell metacharacters.

Locations:

- `action.yml:135`

### script-injection (severity: high)

Step 'Run the benchmarks': Multiple `inputs.*` expressions are interpolated directly inside the `run:` shell script: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`. These should be passed via `env:` variables instead.

Locations:

- `action.yml:178`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version': The variable `RUNNER_VERSION` is derived from `${{ inputs.runner-version }}` and written to `$GITHUB_OUTPUT` via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without sanitization (`printf '%s' ... | tr -d '\n\r'`). Similarly, `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written to `$GITHUB_OUTPUT` via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline injected into either input could allow an attacker to set arbitrary output variables.

Locations:

- `action.yml:115`
- `action.yml:119`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner': When `VERSION_TYPE=latest`, the action fetches and pipes a remote install script directly to bash without first saving it to a file for inspection or hash verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote URL is compromised or subject to a MITM attack, arbitrary code will execute on the runner.

Locations:

- `action.yml:141`

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

Fixed all security findings in actions/hardened/CodSpeedHQ--action/v4.14.0/action.yml:

1. script-injection / static-inline-injection (all three steps): Added env: blocks to move all ${{ inputs.* }} expressions out of run: scripts. 'Determine runner and kernel version' uses INPUT_RUNNER_VERSION and INPUT_MODE. 'Install CodSpeed runner' uses SKIP_HASH_CHECK_WARNING and EXPECTED_HASH. 'Run the benchmarks' uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG.

2. github-env-injection: All values written to $GITHUB_OUTPUT now sanitized using printf '%s' "$VAR" | tr -d '\n\r' before writing, preventing newline injection attacks.

3. unsafe-shell: Fixed the curl pipe-to-bash pattern in the 'latest' branch by downloading to a temp file first (curl -fsSL -o "$INSTALLER_TMP") then executing separately (bash "$INSTALLER_TMP" --quiet).

