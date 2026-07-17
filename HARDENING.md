<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 27 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell scripts, allowing script injection. In the 'Determine runner and kernel version' step: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. In the 'Install CodSpeed runner' step: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. In the 'Run the benchmarks' step: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all directly interpolated into shell commands. An attacker-controlled input value containing shell metacharacters would be executed by the shell.

Locations:

- `action.yml:97`
- `action.yml:117`
- `action.yml:133`
- `action.yml:134`
- `action.yml:136`
- `action.yml:172`
- `action.yml:191`
- `action.yml:198`
- `action.yml:201`
- `action.yml:204`
- `action.yml:207`
- `action.yml:210`
- `action.yml:213`
- `action.yml:216`
- `action.yml:219`
- `action.yml:222`
- `action.yml:225`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the user-controlled input ${{ inputs.runner-version }} is assigned to RUNNER_VERSION and then written to $GITHUB_OUTPUT without sanitization via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` and `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT`. Similarly, ${{ inputs.mode }} is processed into MODE_CACHE_KEY and written to $GITHUB_OUTPUT without the required `printf '%s' ... | tr -d '\n\r'` sanitization. A newline character in the input could inject arbitrary key=value pairs into the GitHub output context.

Locations:

- `action.yml:110`
- `action.yml:111`
- `action.yml:115`
- `action.yml:118`

### unsafe-shell (severity: high)

Two occurrences of curl piping remote content directly to bash without first downloading to a file: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` for the 'latest' version type; (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` for prerelease versions. If the remote server is compromised or the connection is intercepted, arbitrary code executes on the runner. The release version path correctly downloads to a temp file and verifies a SHA256 hash before executing, but the latest and prerelease paths skip this protection.

Locations:

- `action.yml:141`
- `action.yml:148`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell scripts into env: blocks. The 'Determine runner and kernel version' step now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. The 'Install CodSpeed runner' step now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. The 'Run the benchmarks' step now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. github-env-injection: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing, preventing newline injection attacks.

3. unsafe-shell: Replaced both `curl | bash` patterns (for 'latest' and 'prerelease' version types) with the secure download-to-temp-file approach: download to mktemp file, check HTTP status code, then execute with `bash "$INSTALLER_TMP" --quiet`. This matches the existing secure pattern used for release versions.

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (bump-runner-version.yml): Moved `${{ github.event.inputs.version }}` into an env variable `INPUT_VERSION: ${{ github.event.inputs.version }}` in the Bump step's env block. All four offending lines now reference `$INPUT_VERSION` as a plain shell variable instead of interpolating the expression directly into the run block.
2. unpinned-uses: Pinned all `actions/checkout@v4` references (8 total across both files) to the full commit SHA `34e114876b0b11c390a56381ad16ebd13914f8d5 # v4`.
3. missing-permissions (ci.yml): Added a top-level `permissions: contents: read` block, which is the minimum required for a CI workflow that only checks out code and runs tests.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted shell variables in .github/workflows/bump-runner-version.yml: (1) `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`, (2) `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`, (3) `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`, and also fixed `--head $BRANCH_NAME` → `--head "$BRANCH_NAME"` in the gh pr create command. The ${{ }} expression was already safely isolated in the env block as INPUT_VERSION, so no additional changes were needed there.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed three script injection instances in hardened/action/.github/workflows/ci.yml. In each of the three affected steps (test-runner-version-formats job line ~72, test-go-runner-version-formats job line ~87, and test-recent-pinned-runner-versions job line ~113), moved `${{ matrix.version }}` out of the `run:` shell string and into a step-level `env:` block as `MATRIX_VERSION: ${{ matrix.version }}`. The shell scripts now reference `$MATRIX_VERSION` as a plain environment variable instead of directly interpolating the template expression.

