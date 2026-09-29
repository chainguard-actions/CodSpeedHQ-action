<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 34 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): The 'Determine runner and kernel version' run: block directly interpolates ${{ inputs.runner-version }}, ${{ runner.os }}, and ${{ inputs.mode }} as shell text via YAML template substitution before the shell ever sees the script. An attacker-controlled input value containing shell metacharacters (e.g. $(cmd), backticks, semicolons) would be executed. Offending lines include: RUNNER_VERSION="${{ inputs.runner-version }}", DISTRO="${{ runner.os }}", and MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-').

Locations:

- `action.yml:114`
- `action.yml:130`
- `action.yml:134`

### script-injection (severity: high)

Rule (a): The 'Install CodSpeed runner' run: block directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} as shell text. These values flow through YAML template substitution before the shell parses the script, enabling shell metacharacter injection. Offending lines include: RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}", VERSION_TYPE="${{ steps.versions.outputs.version-type }}", SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}", and EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}".

Locations:

- `action.yml:157`
- `action.yml:158`
- `action.yml:160`
- `action.yml:192`

### script-injection (severity: high)

Rule (a): The 'Run the benchmarks' run: block directly interpolates numerous ${{ inputs.* }} expressions as shell text, including inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, inputs.config, inputs.cycle-estimation, inputs.exclude-allocations, and inputs.simulation-track-subprocess. Any caller-supplied input containing shell metacharacters would be executed as shell commands.

Locations:

- `action.yml:218`
- `action.yml:224`
- `action.yml:227`
- `action.yml:230`
- `action.yml:233`
- `action.yml:236`
- `action.yml:239`
- `action.yml:242`
- `action.yml:245`
- `action.yml:248`
- `action.yml:251`
- `action.yml:254`
- `action.yml:257`
- `action.yml:260`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' run: block writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization. Specifically: (1) echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT where RUNNER_VERSION was set from ${{ inputs.runner-version }} — a caller-controlled value that could contain newlines to inject additional output variables; (2) echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT where MODE_CACHE_KEY is derived from ${{ inputs.mode }}. Neither write is preceded by the required printf '%s' ... | tr -d '\n\r' sanitization step.

Locations:

- `action.yml:122`
- `action.yml:135`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths without first downloading to a file for inspection or hash verification: (1) curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet (used when runner-version is 'latest'); (2) curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet (used for prerelease versions). If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner.

Locations:

- `action.yml:167`
- `action.yml:173`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:116`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:296`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Rewrote action.yml to fix all security findings:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }}, ${{ runner.os }}, and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks. The shell scripts now reference them as plain environment variables (INPUT_MODE, INPUT_TOKEN, RUNNER_VERSION, etc.).

2. github-env-injection: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. Applied to runner-version, version-type, kernel-version, distro, and mode-cache-key outputs.

3. unsafe-shell: Replaced both `curl ... | bash -s -- --quiet` patterns with download-to-tempfile-then-execute patterns. For 'latest': `curl -fsSL https://codspeed.io/install.sh -o "$INSTALL_SCRIPT"` then `bash "$INSTALL_SCRIPT" --quiet`. For 'prerelease': same pattern with versioned URL. The '--' was dropped as required (it was the shell's option terminator, not the script's argument). The release version already used download-then-verify and was preserved.

