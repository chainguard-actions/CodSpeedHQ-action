<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.15.0** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are directly interpolated inside `run:` shell blocks, violating sub-rule (a). In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are embedded directly in shell. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are interpolated directly. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly in shell. An attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) can achieve arbitrary command execution.

Locations:

- `action.yml:96`
- `action.yml:119`
- `action.yml:138`
- `action.yml:141`
- `action.yml:143`
- `action.yml:168`
- `action.yml:176`
- `action.yml:183`
- `action.yml:188`
- `action.yml:193`
- `action.yml:197`
- `action.yml:201`
- `action.yml:204`
- `action.yml:208`
- `action.yml:212`
- `action.yml:216`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, when `VERSION_TYPE` is 'latest', the script pipes a remote install script directly to bash without downloading it to a file first: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This allows a compromised or malicious remote server to execute arbitrary code on the runner.

Locations:

- `action.yml:152`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two untrusted input values are written to `$GITHUB_OUTPUT` without newline sanitization: (1) `RUNNER_VERSION` is derived from `${{ inputs.runner-version }}` and written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`; (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (via `echo "${{ inputs.mode }}" | tr ',' '-'`) and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` transformation does not strip newline characters (`\n`, `\r`), so a crafted input containing a newline can inject arbitrary key=value pairs into GITHUB_OUTPUT, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:108`
- `action.yml:113`

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

**Fixes applied:** script-injection, unsafe-shell, github-env-injection, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks. The three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks') now reference values via environment variables (INPUT_MODE, INPUT_TOKEN, INPUT_RUNNER_VERSION, etc.).

2. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a two-step approach: download to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"`), then execute (`bash "$INSTALL_SCRIPT" --quiet`). The `--` was correctly dropped as it was the shell's stdin option terminator, not an argument to the install script.

3. **github-env-injection**: Both values written to $GITHUB_OUTPUT are now sanitized with `tr -d '\n\r'` before writing: RUNNER_VERSION uses `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'`, and MODE_CACHE_KEY uses `printf '%s' "$INPUT_MODE" | tr -d '\n\r' | tr ',' '-'`.

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (bump-runner-version.yml lines 24,27,28,31): Moved `${{ github.event.inputs.version }}` into the step's `env:` block as `INPUT_VERSION`, then replaced all four direct interpolations in the `run:` shell block with `$INPUT_VERSION`. 2. unpinned-uses: Replaced all 8 occurrences of `actions/checkout@v4` (1 in bump-runner-version.yml, 7 in ci.yml) with the pinned SHA `actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4`. 3. missing-permissions (ci.yml): Added a top-level `permissions: contents: read` block, which is the minimum permission needed for the checkout and read-only CI operations performed by this workflow.

