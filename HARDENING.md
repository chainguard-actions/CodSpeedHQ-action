<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml, allowing script injection. In the 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. Any attacker-controlled value for `inputs.runner-version` or `inputs.mode` is expanded by the YAML template engine before the shell ever sees it, enabling command injection.

Locations:

- `action.yml:100`
- `action.yml:117`

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside the 'Install CodSpeed runner' `run:` block: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. These are all substituted by the template engine before the shell parses the script, enabling injection.

Locations:

- `action.yml:137`
- `action.yml:138`
- `action.yml:140`
- `action.yml:172`

### script-injection (severity: high)

Rule (a): The 'Run the benchmarks' `run:` block directly interpolates numerous `${{ inputs.* }}` expressions into shell: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. Each is a potential script injection vector since the YAML template substitution occurs before shell parsing.

Locations:

- `action.yml:196`
- `action.yml:200`
- `action.yml:203`
- `action.yml:206`
- `action.yml:209`
- `action.yml:212`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`
- `action.yml:227`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without sanitization. `$RUNNER_VERSION` (set from `${{ inputs.runner-version }}`) is written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`, and `$MODE_CACHE_KEY` (derived from `${{ inputs.mode }}`) is written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step, allowing newline injection into the output file.

Locations:

- `action.yml:118`
- `action.yml:125`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. The script is not downloaded to a file first and verified before execution. If the remote server is compromised or the connection is intercepted, arbitrary code will be executed on the runner.

Locations:

- `action.yml:145`

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

Fixed all findings in action.yml:

1. **Determine runner and kernel version step**: Moved `${{ inputs.runner-version }}` and `${{ inputs.mode }}` to env block as `INPUT_RUNNER_VERSION` and `INPUT_MODE`. Sanitized all GITHUB_OUTPUT writes with `printf '%s' "$VAR" | tr -d '\n\r'`.

2. **Install CodSpeed runner step**: Moved `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` to env block. Removed the remaining inline `${{ steps.installer-hash.outputs.hash }}` from the run block (now uses `$EXPECTED_HASH` env var). Fixed unsafe `curl | bash` by downloading to a temp file first and executing separately (dropping the `--` shell option terminator as required).

3. **Run the benchmarks step**: Moved all 11 `${{ inputs.* }}` expressions to the env block and replaced all inline expressions in the run block with env var references (`$INPUT_MODE`, `$INPUT_TOKEN`, etc.).

