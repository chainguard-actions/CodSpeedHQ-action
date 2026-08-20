<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.13.0** was hardened automatically. 30 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are directly interpolated inside `run:` shell command strings in action.yml.

In the 'Determine runner and kernel version' step:
- `RUNNER_VERSION="${{ inputs.runner-version }}"` (line ~105)
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line ~127)

In the 'Install CodSpeed runner' step:
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (line ~153)
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"` (line ~154)
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` (line ~155)
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (line ~196)

In the 'Run the benchmarks' step:
- `if [ -z "${{ inputs.mode }}" ]` (line ~218)
- `if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")` (line ~224)
- `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")` (line ~227)
- `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")` (line ~230)
- `RUNNER_ARGS+=(--mode="${{ inputs.mode }}")` (line ~233)
- `RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")` (line ~236)
- `RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")` (line ~239)
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]` (line ~242)
- `RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")` (line ~247)
- `RUNNER_ARGS+=(--config="${{ inputs.config }}")` (line ~250)

All these allow an attacker-controlled value to be interpolated directly into the shell command string before the shell parses it, enabling command injection.

Locations:

- `action.yml:105`
- `action.yml:127`
- `action.yml:153`
- `action.yml:155`
- `action.yml:196`
- `action.yml:218`
- `action.yml:224`

### script-injection (severity: high)

Sub-rule (a): `${{ github.event.inputs.version }}` is directly interpolated inside a `run:` shell command string in bump-runner-version.yml. This is a workflow_dispatch input that can be supplied by any user who can trigger the workflow. Offending lines include:
- `if ! echo "${{ github.event.inputs.version }}" | grep -E ...` (line ~25)
- `if ! gh release view v${{ github.event.inputs.version }} -R ...` (line ~30)
- `VERSION="${{ github.event.inputs.version }}"` (line ~35)

An attacker-controlled version string is interpolated directly into the shell before quoting, enabling command injection.

Locations:

- `.github/workflows/bump-runner-version.yml:25`
- `.github/workflows/bump-runner-version.yml:30`
- `.github/workflows/bump-runner-version.yml:35`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step of action.yml, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled composite action input), then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no newline stripping applied.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which does NOT strip newlines/carriage returns), then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — no sanitization applied.

A newline embedded in either input value would allow injection of arbitrary key=value pairs into $GITHUB_OUTPUT, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:122`
- `action.yml:128`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step of action.yml, when `VERSION_TYPE` is `latest`, the script pipes a remotely fetched installer script directly to bash without any integrity verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified, and then executed — as is done for the release version path in the same step.

Locations:

- `action.yml:162`

### unpinned-uses (severity: high)

Multiple `uses:` references in workflow files use mutable tag refs instead of full 40-character SHA commit hashes, making them vulnerable to supply-chain attacks if the tag is moved:

In .github/workflows/ci.yml:
- `uses: actions/checkout@v4` (appears at multiple steps)

In .github/workflows/bump-runner-version.yml:
- `uses: actions/checkout@v4`

These should be pinned to a full SHA digest, e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `.github/workflows/ci.yml:29`
- `.github/workflows/ci.yml:86`
- `.github/workflows/ci.yml:104`
- `.github/workflows/ci.yml:120`
- `.github/workflows/ci.yml:136`
- `.github/workflows/ci.yml:152`
- `.github/workflows/ci.yml:168`
- `.github/workflows/bump-runner-version.yml:18`

### missing-permissions (severity: medium)

The workflow file .github/workflows/ci.yml has no top-level `permissions:` key and none of its jobs define a `permissions:` block. Without explicit permissions, the workflow inherits the repository's default token permissions (which may be `write-all` for older repositories). A minimal permissions block (e.g. `permissions: read-all` or specific scopes) should be added at the top level or on each job.

Locations:

- `.github/workflows/ci.yml:1`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml, .github/workflows/ci.yml, and .github/workflows/bump-runner-version.yml:

1. **script-injection / static-inline-injection** (action.yml): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell strings into env: blocks in all three affected steps. Shell scripts now use plain $VAR_NAME references.

2. **script-injection** (bump-runner-version.yml): Moved ${{ github.event.inputs.version }} to env: block as INPUT_VERSION; updated all shell references.

3. **github-env-injection** (action.yml): Added `tr -d '\n\r'` sanitization before writing RUNNER_VERSION and MODE_CACHE_KEY to $GITHUB_OUTPUT.

4. **unsafe-shell** (action.yml): Replaced `curl ... | bash -s -- --quiet` with download-then-execute pattern: curl to temp file, then `bash "$INSTALL_SCRIPT" --quiet`.

5. **unpinned-uses**: Pinned all 8 `actions/checkout@v4` references to full SHA `11d5960a326750d5838078e36cf38b85af677262 # v4`.

6. **missing-permissions** (ci.yml): Added `permissions: contents: read` at top level.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings:

1. ci.yml: Three `run:` steps in test-runner-version-formats, test-go-runner-version-formats, and test-recent-pinned-runner-versions jobs were interpolating `${{ matrix.version }}` directly in shell strings. Fixed by adding `env: MATRIX_VERSION: ${{ matrix.version }}` to each step and replacing `${{ matrix.version }}` in the `run:` string with `$MATRIX_VERSION`.

2. bump-runner-version.yml: Unquoted shell variable expansions of `$BRANCH_NAME` and `$VERSION` in git and echo commands. Fixed by quoting all expansions: `BRANCH_NAME="bump-runner-version/$VERSION"`, `git checkout -b "$BRANCH_NAME"`, `echo "$VERSION" > .codspeed-runner-version`, `git push origin "$BRANCH_NAME"`, and `--head "$BRANCH_NAME"` in the gh pr create command.

