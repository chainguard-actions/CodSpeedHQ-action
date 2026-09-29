<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.2** was hardened automatically. 33 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version': ${{ inputs.runner-version }} and ${{ inputs.mode }} are interpolated directly inside the run: shell script (sub-rule a). An attacker-controlled value is expanded by the YAML template engine before the shell ever sees it, enabling command injection. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:110`
- `action.yml:130`

### script-injection (severity: high)

Step 'Install CodSpeed runner': Multiple ${{ ... }} expressions are interpolated directly inside the run: shell script (sub-rule a). Affected expressions: `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}`. These are all expanded by the YAML template engine before the shell parses the script, enabling command injection via attacker-controlled inputs.

Locations:

- `action.yml:173`
- `action.yml:174`
- `action.yml:176`

### script-injection (severity: high)

Step 'Run the benchmarks': Numerous ${{ inputs.* }} expressions are interpolated directly inside the run: shell script (sub-rule a), including: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, `${{ inputs.config }}`, `${{ inputs.cycle-estimation }}`, `${{ inputs.exclude-allocations }}`. Each is expanded by the YAML template engine before the shell parses the script, enabling command injection via attacker-controlled inputs.

Locations:

- `action.yml:270`
- `action.yml:278`
- `action.yml:281`
- `action.yml:284`
- `action.yml:287`
- `action.yml:290`
- `action.yml:293`
- `action.yml:296`
- `action.yml:299`
- `action.yml:302`
- `action.yml:305`
- `action.yml:308`
- `action.yml:311`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version': Two values derived from untrusted inputs are written to $GITHUB_OUTPUT without sanitization. (1) `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — a newline in the input value could inject additional output variables. (2) `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` with the same risk. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step.

Locations:

- `action.yml:126`
- `action.yml:131`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' pipes remote shell scripts directly to bash without downloading to a file first. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when VERSION_TYPE=latest); (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used when VERSION_TYPE=prerelease). If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner.

Locations:

- `action.yml:186`
- `action.yml:192`

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

Fixed all findings in hardened/action/action.yml:

1. **Determine runner and kernel version** step:
   - Moved `${{ inputs.runner-version }}` and `${{ inputs.mode }}` to `env:` block as `INPUT_RUNNER_VERSION` and `INPUT_MODE`
   - Added `printf '%s' ... | tr -d '\n\r'` sanitization before writing `runner-version` and `mode-cache-key` to `$GITHUB_OUTPUT`
   - Quoted `$GITHUB_OUTPUT` references

2. **Install CodSpeed runner** step:
   - Moved `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` to `env:` block
   - Removed duplicate inline `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` from script body (now comes from env)
   - Fixed two `curl ... | bash -s -- --quiet` patterns: now downloads to temp file first, then executes with `bash "$INSTALL_SCRIPT" --quiet` (dropping `--` which was the shell's option terminator)

3. **Run the benchmarks** step:
   - Moved all 13 `${{ inputs.* }}` expressions to `env:` block with `INPUT_*` names
   - Updated all script references to use the environment variables

