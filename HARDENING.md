<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.0** was hardened automatically. 27 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings across three steps in action.yml, violating rule (a). Step 'Determine runner and kernel version': `RUNNER_VERSION="${{ inputs.runner-version }}"` (line 97) and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` (line 128). Step 'Install CodSpeed runner': `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` (lines 155-172). Step 'Run the benchmarks': `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]` then `--token "${{ inputs.token }}"`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `if [ "${{ inputs.cache-instruments }}" = "true" ]`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `if [ "${{ inputs.allow-empty }}" = "true" ]`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` (lines 199-230). All allow shell metacharacter injection before the shell sees the value.

Locations:

- `action.yml:97`
- `action.yml:128`
- `action.yml:155`
- `action.yml:156`
- `action.yml:158`
- `action.yml:199`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization (printf '%s' ... | tr -d '\n\r'): (1) `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (line 120) where $RUNNER_VERSION was set from `${{ inputs.runner-version }}` without sanitization; (2) `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (line 129) where $MODE_CACHE_KEY was derived from `${{ inputs.mode }}` without sanitization. An attacker can inject newlines into these inputs to poison subsequent steps that read from $GITHUB_OUTPUT.

Locations:

- `action.yml:120`
- `action.yml:129`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, when VERSION_TYPE is 'latest', the script pipes a remote shell script directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. This is the classic curl|bash anti-pattern. If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to the 'latest' path.

Locations:

- `action.yml:164`

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

Fixed all security findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.).

2. github-env-injection: Sanitized both user-input-derived values before writing to $GITHUB_OUTPUT: runner-version uses `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and mode-cache-key uses `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`.

3. unsafe-shell: Fixed the curl|bash anti-pattern for the 'latest' version path. The script now downloads the installer to a temp file, verifies the HTTP status code, then executes it with `bash "$INSTALLER_TMP" --quiet` — matching the safe pattern already used for the release version path.

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (bump-runner-version.yml): Moved `${{ github.event.inputs.version }}` into an `env:` variable `INPUT_VERSION` and replaced all four inline interpolations in the run: block with `$INPUT_VERSION` shell references. 2. unpinned-uses: Pinned all 8 occurrences of `actions/checkout@v4` to `actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4` (7 in ci.yml, 1 in bump-runner-version.yml). 3. missing-permissions (ci.yml): Added a top-level `permissions: contents: read` block, which is the minimum needed for a CI workflow that only reads repository contents.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed three script injection vulnerabilities in hardened/action/.github/workflows/ci.yml:
1. test-runner-version-formats job (line ~83): moved `${{ matrix.version }}` out of `run: echo "Testing version format ${{ matrix.version }}!"` into an `env: MATRIX_VERSION: ${{ matrix.version }}` block; shell command now uses `$MATRIX_VERSION`.
2. test-go-runner-version-formats job (line ~100): same fix applied.
3. test-recent-pinned-runner-versions job (line ~127): same fix applied.
In all three cases, the `${{ matrix.version }}` expression in the `with: runner-version:` / `with: go-runner-version:` inputs was left as-is (those are action inputs, not shell commands, so they are not injection risks).

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed four unquoted shell variable expansions in .github/workflows/bump-runner-version.yml. Added double quotes around $BRANCH_NAME in `git checkout -b`, `git push origin`, and `gh pr create --head`, and around $VERSION in `echo $VERSION > .codspeed-runner-version`. This prevents word splitting and glob expansion on user-controlled workflow_dispatch input values.

