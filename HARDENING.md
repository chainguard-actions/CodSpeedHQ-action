<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.18.2** was hardened automatically. 29 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Determine runner and kernel version' run: block directly interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} into shell commands. These expressions are substituted by the YAML template engine before the shell sees them, allowing an attacker-controlled value to inject arbitrary shell commands. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Locations:

- `action.yml:99`
- `action.yml:121`

### script-injection (severity: high)

Sub-rule (a): The 'Install CodSpeed runner' run: block directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} into shell commands. Any of these values flowing from attacker-controlled inputs can inject shell metacharacters. Offending lines include: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:141`
- `action.yml:142`
- `action.yml:144`
- `action.yml:175`

### script-injection (severity: high)

Sub-rule (a): The 'Run the benchmarks' run: block directly interpolates numerous ${{ inputs.* }} expressions into shell commands, including inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, and inputs.config. These are substituted before the shell executes, enabling command injection via crafted input values. Example: `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")` and `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")`.

Locations:

- `action.yml:207`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`
- `action.yml:228`
- `action.yml:231`
- `action.yml:234`
- `action.yml:237`
- `action.yml:240`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step interpolates ${{ inputs.mode }} directly into a shell command (`MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`) and then writes the result to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). An attacker-controlled inputs.mode value containing newlines could inject arbitrary key=value pairs into $GITHUB_OUTPUT. Similarly, ${{ inputs.runner-version }} is interpolated and RUNNER_VERSION is written to $GITHUB_OUTPUT unsanitized.

Locations:

- `action.yml:99`
- `action.yml:115`
- `action.yml:121`
- `action.yml:122`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote script content directly to bash in two code paths: (1) for 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`; (2) for 'prerelease' version: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`. The script is not downloaded to a file first and verified before execution, allowing a compromised or MITM'd remote script to execute arbitrary code.

Locations:

- `action.yml:150`
- `action.yml:156`

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

Fixed all security findings in hardened/action/action.yml:
1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables.
2. github-env-injection: All values written to $GITHUB_OUTPUT are now sanitized using 'printf "%s" "$VAR" | tr -d "\n\r"' before writing, preventing newline injection.
3. unsafe-shell: Replaced both 'curl ... | bash' patterns (for 'latest' and 'prerelease' versions) with download-to-temp-file-then-execute patterns using mktemp + curl -o + bash.

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all three findings: (1) script-injection in bump-runner-version.yml — moved `github.event.inputs.version` into an `env:` block as `VERSION` and replaced all 4 direct `${{ github.event.inputs.version }}` interpolations in the run: block with `$VERSION`; (2) unpinned-uses — pinned all 8 occurrences of `actions/checkout@v4` to the full commit SHA `34e114876b0b11c390a56381ad16ebd13914f8d5 # v4` across both workflow files; (3) missing-permissions — added `permissions: contents: read` top-level block to ci.yml.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted shell variable expansions in .github/workflows/bump-runner-version.yml. The VERSION variable (sourced from github.event.inputs.version) and BRANCH_NAME (derived from VERSION) were used unquoted in 4 locations. Fixed by: (1) quoting BRANCH_NAME assignment: "bump-runner-version/$VERSION", (2) quoting git checkout -b "$BRANCH_NAME", (3) quoting echo "$VERSION" > .codspeed-runner-version, (4) quoting git push origin "$BRANCH_NAME", and also quoting --head "$BRANCH_NAME" in the gh pr create command for completeness.

