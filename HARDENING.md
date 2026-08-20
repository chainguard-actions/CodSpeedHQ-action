<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.5** was hardened automatically. 27 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ }}` expressions from untrusted inputs and step outputs are directly interpolated inside `run:` shell command strings across three steps.

**Step 1 – "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input values are substituted directly into the shell before the shell ever sees them, enabling command injection.

**Step 3 – "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly into the shell script.

**Step 4 – "Run the benchmarks"**: `if [ -z "${{ inputs.mode }}" ]`, `if [ -n "${{ inputs.token }}" ]`, `--token "${{ inputs.token }}"`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `if [ "${{ inputs.cache-instruments }}" = "true" ]`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `if [ "${{ inputs.allow-empty }}" = "true" ]`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` — all directly interpolated. Any of these inputs containing shell metacharacters (`;`, `|`, `$(...)`, etc.) will be executed by the shell.

Locations:

- `action.yml:88`
- `action.yml:108`
- `action.yml:134`
- `action.yml:135`
- `action.yml:137`
- `action.yml:170`
- `action.yml:192`

### github-env-injection (severity: high)

Step 1 ("Determine runner and kernel version") writes values derived from untrusted inputs to `$GITHUB_OUTPUT` without sanitization. `$RUNNER_VERSION` is derived from `${{ inputs.runner-version }}` and written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. `$MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required sanitization step (`printf '%s' "$VAR" | tr -d '\n\r'`). A newline character in either input value could inject arbitrary key=value pairs into the GitHub output environment, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:110`
- `action.yml:113`

### unsafe-shell (severity: high)

In the "Install CodSpeed runner" step, when `VERSION_TYPE` is `latest`, the script pipes a remote shell script directly to bash without first downloading and verifying it: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code will be executed on the runner. The release-version path correctly downloads to a temp file and verifies a SHA-256 hash first, but the `latest` path bypasses this protection entirely.

Locations:

- `action.yml:143`

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
1. Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks to env: blocks across all three affected steps (Determine runner and kernel version, Install CodSpeed runner, Run the benchmarks). Shell scripts now reference plain env vars like $INPUT_MODE, $INPUT_TOKEN, $RUNNER_VERSION, etc.
2. Sanitized all GITHUB_OUTPUT writes using `printf '%s' "$VAR" | tr -d '\n\r'` to prevent newline injection.
3. Fixed unsafe curl|bash pipe in the 'latest' version path: now downloads install.sh to a temp file first, then executes it with `bash "$INSTALLER_TMP" --quiet` (dropping the '--' that was the shell's option terminator in the pipe form).

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (bump-runner-version.yml): Moved `${{ github.event.inputs.version }}` into the step's `env:` block as `INPUT_VERSION`. All shell references now use `$INPUT_VERSION` instead of the inline expression, preventing command injection.
2. unpinned-uses: Pinned all 8 occurrences of `actions/checkout@v4` to the full commit SHA `11d5960a326750d5838078e36cf38b85af677262 # v4` — 7 in ci.yml and 1 in bump-runner-version.yml.
3. missing-permissions (ci.yml): Added a top-level `permissions: contents: read` block. The CI workflow only needs to read repository contents for checkout and local action execution, so read-only is the minimum required.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed all unquoted variable expansions in the 'Bump' step of bump-runner-version.yml. Specifically: (1) BRANCH_NAME assignment now uses double quotes around the value, (2) `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`, (3) `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`, (4) `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`, and (5) `--head $BRANCH_NAME` → `--head "$BRANCH_NAME"`. All workflow-controllable env vars are now properly double-quoted throughout the shell script.

