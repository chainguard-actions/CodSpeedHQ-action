# Hardening Report: CodSpeedHQ--action/v4.13.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.13.1** was hardened automatically. 29 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

The 'Determine runner and kernel version' run: step directly interpolates attacker-controlled inputs expressions into shell commands without first assigning them to env: variables. Specifically, `${{ inputs.runner-version }}` is interpolated on line ~91 and `${{ inputs.mode }}` is interpolated on line ~118. An attacker who controls these inputs can inject arbitrary shell commands.

Locations:

- `action.yml:91`
- `action.yml:118`

### script-injection (severity: high)

The 'Install CodSpeed runner' run: step directly interpolates `${{ inputs.skip-hash-check-warning }}` into the shell script (line ~154) without first assigning it to an env: variable. An attacker who controls this input can inject arbitrary shell commands.

Locations:

- `action.yml:154`

### script-injection (severity: high)

The 'Run the benchmarks' run: step directly interpolates multiple attacker-controlled inputs expressions into shell commands without first assigning them to env: variables. Affected inputs include: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. An attacker who controls any of these inputs can inject arbitrary shell commands.

Locations:

- `action.yml:229`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, `${{ inputs.mode }}` is directly interpolated into a shell pipeline (`MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`) and the result is then written to $GITHUB_OUTPUT (`echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`) without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline-containing input value could inject additional key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:118`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes a remotely fetched script directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This executes whatever content is served at that URL without first saving it to a file for inspection or verification. If the remote URL is compromised, arbitrary code will execute on the runner.

Locations:

- `action.yml:162`

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

Fixed all security findings in actions/hardened/CodSpeedHQ--action/v4.13.1/action.yml:

1. script-injection (Determine runner and kernel version): Moved ${{ inputs.runner-version }} and ${{ inputs.mode }} to env: block as INPUT_RUNNER_VERSION and INPUT_MODE.

2. script-injection (Install CodSpeed runner): Moved ${{ inputs.skip-hash-check-warning }} and step outputs to env: block (SKIP_HASH_CHECK_WARNING, RUNNER_VERSION, VERSION_TYPE, EXPECTED_HASH).

3. script-injection (Run the benchmarks): Moved all 11 ${{ inputs.* }} expressions to env: block (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG).

4. github-env-injection: Fixed MODE_CACHE_KEY to use printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r' before writing to $GITHUB_OUTPUT.

5. unsafe-shell: Fixed curl | bash pattern in 'latest' version branch by downloading to a temp file first, then executing separately.

All ${{ inputs.* }} expressions now only appear in env: blocks or non-shell contexts (with:, if:), never directly in run: shell scripts.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection vulnerability in the 'Determine runner and kernel version' step (action.yml lines 123-124). The RUNNER_VERSION and VERSION_TYPE variables (derived from attacker-controlled input `inputs.runner-version`) were written to $GITHUB_OUTPUT without sanitization. Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization for both values before writing them to $GITHUB_OUTPUT, preventing newline injection attacks that could poison the output file and set arbitrary output variables.

