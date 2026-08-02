<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.2** was hardened automatically. 37 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Direct expression interpolation in run: block. The 'Determine runner and kernel version' step interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} directly inside shell commands before the shell parses them, enabling command injection. Offending lines: RUNNER_VERSION="${{ inputs.runner-version }}" and MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-').

Locations:

- `action.yml:105`
- `action.yml:127`

### script-injection (severity: high)

Sub-rule (a): Direct expression interpolation in run: block. The 'Install CodSpeed runner' step interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} directly inside shell commands, enabling command injection via user-controlled inputs.

Locations:

- `action.yml:148`
- `action.yml:149`
- `action.yml:151`

### script-injection (severity: high)

Sub-rule (a): Direct expression interpolation in run: block. The 'Run the benchmarks' step interpolates many ${{ inputs.* }} expressions directly inside shell commands including inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, inputs.config, inputs.cycle-estimation, and inputs.exclude-allocations, enabling command injection via any of these inputs.

Locations:

- `action.yml:210`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`
- `action.yml:227`
- `action.yml:230`
- `action.yml:233`
- `action.yml:236`
- `action.yml:239`
- `action.yml:242`
- `action.yml:245`
- `action.yml:248`

### script-injection (severity: high)

Sub-rule (a): Direct expression interpolation in run: block. The 'Bump' step in bump-runner-version.yml interpolates ${{ github.event.inputs.version }} directly inside shell commands multiple times (in echo, gh release view, and VERSION assignment), enabling command injection via the workflow_dispatch version input.

Locations:

- `.github/workflows/bump-runner-version.yml:26`
- `.github/workflows/bump-runner-version.yml:31`
- `.github/workflows/bump-runner-version.yml:35`

### script-injection (severity: high)

Sub-rule (a): Direct expression interpolation in run: block. In ci.yml, ${{ matrix.version }} is interpolated directly inside run: shell commands in test-runner-version-formats, test-go-runner-version-formats, and test-recent-pinned-runner-versions jobs. Matrix values are workflow-controllable and must not be interpolated directly into shell.

Locations:

- `.github/workflows/ci.yml:84`
- `.github/workflows/ci.yml:107`
- `.github/workflows/ci.yml:131`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, RUNNER_VERSION (derived from ${{ inputs.runner-version }}) is written to $GITHUB_OUTPUT without sanitization: echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT. MODE_CACHE_KEY (derived from ${{ inputs.mode }}) is also written to $GITHUB_OUTPUT without sanitization: echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT. Neither write is preceded by the required printf '%s' ... | tr -d '\n\r' sanitization, allowing newline injection.

Locations:

- `action.yml:119`
- `action.yml:129`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash without downloading to a file first. Two occurrences: (1) curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet for the 'latest' version path, and (2) curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet for the 'prerelease' version path. If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner.

Locations:

- `action.yml:155`
- `action.yml:162`

### unpinned-uses (severity: high)

Multiple uses: references in ci.yml use the mutable tag @v4 instead of a full 40-character commit SHA. All occurrences of uses: actions/checkout@v4 are unpinned, allowing the upstream repository to silently change what code runs.

Locations:

- `.github/workflows/ci.yml:36`
- `.github/workflows/ci.yml:83`
- `.github/workflows/ci.yml:106`
- `.github/workflows/ci.yml:122`
- `.github/workflows/ci.yml:130`
- `.github/workflows/ci.yml:148`
- `.github/workflows/ci.yml:157`
- `.github/workflows/ci.yml:163`
- `.github/workflows/ci.yml:170`

### unpinned-uses (severity: high)

The uses: actions/checkout@v4 reference in bump-runner-version.yml uses the mutable tag @v4 instead of a full 40-character commit SHA, allowing the upstream repository to silently change what code runs in this workflow.

Locations:

- `.github/workflows/bump-runner-version.yml:19`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell, unpinned-uses

**Notes:**

Fixed all findings across action.yml, .github/workflows/bump-runner-version.yml, and .github/workflows/ci.yml:

1. **script-injection / static-inline-injection (action.yml)**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables.

2. **github-env-injection (action.yml)**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before all writes to $GITHUB_OUTPUT in the 'Determine runner and kernel version' step (runner-version, version-type, kernel-version, mode-cache-key).

3. **unsafe-shell (action.yml)**: Fixed both `curl | bash` patterns in 'Install CodSpeed runner' by downloading the installer script to a temp file first (`curl ... -o "$INSTALLER_TMP"`), then executing it separately (`bash "$INSTALLER_TMP" --quiet`).

4. **script-injection (bump-runner-version.yml)**: Moved `${{ github.event.inputs.version }}` to env: block as INPUT_VERSION; updated all shell references accordingly.

5. **unpinned-uses**: Pinned all 10 occurrences of `actions/checkout@v4` to the full SHA `actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4` in ci.yml (9 occurrences) and bump-runner-version.yml (1 occurrence).

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in .github/workflows/bump-runner-version.yml by double-quoting all unquoted variable expansions in the 'Bump' step:
1. `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`
2. `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`
3. `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`
4. `--head $BRANCH_NAME` → `--head "$BRANCH_NAME"`

Note: The INPUT_VERSION variable is already correctly placed in the step's `env:` block (not inline in the `run:` script), and the script already validates the version against a strict semver regex before use. The double-quoting prevents shell word-splitting and glob expansion attacks from any user-controlled input that might bypass the regex check.

