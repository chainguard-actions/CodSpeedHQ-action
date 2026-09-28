<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 29 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 1 ('Determine runner and kernel version'): `${{ inputs.runner-version }}` (line 104) and `${{ inputs.mode }}` (line 137) are interpolated directly inside the `run:` shell script. Before the shell ever sees the command, GitHub Actions substitutes these expressions as raw text, allowing an attacker-controlled value to inject arbitrary shell commands. Rule (a) violation.

Locations:

- `action.yml:104`
- `action.yml:137`

### script-injection (severity: high)

Step 3 ('Install CodSpeed runner'): `${{ steps.versions.outputs.runner-version }}` (line 166), `${{ steps.versions.outputs.version-type }}` (line 167), `${{ inputs.skip-hash-check-warning }}` (line 169), and `${{ steps.installer-hash.outputs.hash }}` (~line 222) are all interpolated directly inside the `run:` shell script. These values flow from user-controlled inputs and step outputs, enabling shell command injection. Rule (a) violation.

Locations:

- `action.yml:166`
- `action.yml:167`
- `action.yml:169`
- `action.yml:222`

### script-injection (severity: high)

Step 4 ('Run the benchmarks'): Eleven `inputs.*` expressions are interpolated directly inside the `run:` shell script: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. An attacker-controlled input value can inject arbitrary shell commands. Rule (a) violation.

Locations:

- `action.yml:256`
- `action.yml:262`
- `action.yml:265`
- `action.yml:268`
- `action.yml:271`
- `action.yml:274`
- `action.yml:277`
- `action.yml:280`
- `action.yml:283`
- `action.yml:286`
- `action.yml:289`

### github-env-injection (severity: high)

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 104) and then written unsanitized to `$GITHUB_OUTPUT` (line 129: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`). Similarly, `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line 137) and written unsanitized to `$GITHUB_OUTPUT` (line 138: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`). Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step, allowing newline injection into the output file.

Locations:

- `action.yml:129`
- `action.yml:138`

### unsafe-shell (severity: high)

Step 3 ('Install CodSpeed runner') pipes remote scripts directly to bash without first downloading to a file for verification. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when runner-version is 'latest'); (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for prerelease versions). If the remote server or network is compromised, arbitrary code executes immediately on the runner.

Locations:

- `action.yml:178`
- `action.yml:188`

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps (Determine runner and kernel version, Install CodSpeed runner, Run the benchmarks). Shell scripts now reference plain environment variables.

2. **github-env-injection**: Added sanitization before writing to $GITHUB_OUTPUT. runner-version is sanitized with `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and mode-cache-key is sanitized with `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. **unsafe-shell**: Replaced both `curl -fsSL ... | bash -s -- --quiet` patterns with download-then-execute: script is downloaded to a temp file via `curl -fsSL ... -o "$INSTALL_SCRIPT"` then executed with `bash "$INSTALL_SCRIPT" --quiet`. The `--` from the original pipe form was correctly dropped (it was the shell's option terminator, not the script's argument).

