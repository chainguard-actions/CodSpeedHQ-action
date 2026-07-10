<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.18.5** was hardened automatically. 30 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions are directly interpolated inside run: shell command strings in action.yml. In the 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. In the 'Install CodSpeed runner' step: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. In the 'Run the benchmarks' step: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into the shell script. Any of these inputs can contain shell metacharacters that will be interpreted by the shell before execution.

Locations:

- `action.yml:95`
- `action.yml:117`
- `action.yml:136`
- `action.yml:137`
- `action.yml:139`
- `action.yml:203`
- `action.yml:208`

### script-injection (severity: high)

Sub-rule (a): In .github/workflows/bump-runner-version.yml, the 'Bump' step directly interpolates ${{ github.event.inputs.version }} into the run: shell script multiple times: `if ! echo "${{ github.event.inputs.version }}" | grep -E ...`, `gh release view v${{ github.event.inputs.version }} -R ...`, `echo "Release ${{ github.event.inputs.version }} does not exist..."`, and `VERSION="${{ github.event.inputs.version }}"`. A workflow_dispatch input containing shell metacharacters could lead to command injection.

Locations:

- `.github/workflows/bump-runner-version.yml:25`
- `.github/workflows/bump-runner-version.yml:30`
- `.github/workflows/bump-runner-version.yml:31`
- `.github/workflows/bump-runner-version.yml:34`

### github-env-injection (severity: high)

In action.yml 'Determine runner and kernel version' step, the variable RUNNER_VERSION (derived from ${{ inputs.runner-version }}) and MODE_CACHE_KEY (derived from ${{ inputs.mode }}) are written to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r'). An attacker-controlled newline in these inputs could inject additional key=value pairs into GITHUB_OUTPUT, poisoning subsequent steps.

Locations:

- `action.yml:110`
- `action.yml:118`

### unsafe-shell (severity: high)

In action.yml 'Install CodSpeed runner' step, remote scripts are fetched and piped directly to bash without downloading to a file first: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when runner-version is 'latest'), and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for prerelease versions). If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner.

Locations:

- `action.yml:145`
- `action.yml:152`

### unpinned-uses (severity: high)

Multiple workflow files use actions/checkout@v4 (a mutable tag reference, not a full 40-character SHA commit hash). This means the action could be silently updated to a malicious version without any change to the workflow file. Affected files: .github/workflows/ci.yml (multiple uses) and .github/workflows/bump-runner-version.yml.

Locations:

- `.github/workflows/ci.yml:27`
- `.github/workflows/ci.yml:75`
- `.github/workflows/ci.yml:95`
- `.github/workflows/ci.yml:113`
- `.github/workflows/ci.yml:128`
- `.github/workflows/ci.yml:143`
- `.github/workflows/bump-runner-version.yml:18`

### missing-permissions (severity: medium)

The workflow file .github/workflows/ci.yml has no top-level permissions: key and none of its jobs (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file) define job-level permissions. Without explicit permissions, the workflow inherits the default repository permissions, which may be overly broad (e.g., write access to contents).

Locations:

- `.github/workflows/ci.yml:1`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml, .github/workflows/bump-runner-version.yml, and .github/workflows/ci.yml:

1. script-injection / static-inline-injection (action.yml): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks. The 'Determine runner and kernel version' step now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. The 'Install CodSpeed runner' step now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. The 'Run the benchmarks' step now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. script-injection (bump-runner-version.yml): Moved ${{ github.event.inputs.version }} to an INPUT_VERSION env var and replaced all direct interpolations with $INPUT_VERSION references.

3. github-env-injection (action.yml): Added printf '%s' ... | tr -d '\n\r' sanitization for all values written to $GITHUB_OUTPUT (runner-version, version-type, kernel-version, mode-cache-key).

4. unsafe-shell (action.yml): Replaced both curl|bash patterns with download-to-tempfile-then-execute patterns: curl -fsSL ... -o "$INSTALLER_TMP" followed by bash "$INSTALLER_TMP" --quiet.

5. unpinned-uses (ci.yml and bump-runner-version.yml): Pinned all actions/checkout@v4 references to the full commit SHA actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 # v4.

6. missing-permissions (ci.yml): Added top-level permissions: contents: read block.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed all unquoted shell variable expansions in .github/workflows/bump-runner-version.yml. The variables $BRANCH_NAME and $VERSION (derived from the workflow_dispatch input) were used unquoted in 5 places: BRANCH_NAME assignment, `git checkout -b`, `echo ... > .codspeed-runner-version`, `git push origin`, and `gh pr create --head`. All are now properly double-quoted to prevent word-splitting and glob expansion of attacker-controlled values.

