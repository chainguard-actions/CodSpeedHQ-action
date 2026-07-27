<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.1** was hardened automatically. 30 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly into shell. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are interpolated directly. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell commands. Any of these values can contain shell metacharacters that will be interpreted by the shell before execution.

Locations:

- `action.yml:95`
- `action.yml:117`
- `action.yml:135`
- `action.yml:136`
- `action.yml:138`
- `action.yml:195`
- `action.yml:200`
- `action.yml:203`
- `action.yml:206`
- `action.yml:209`
- `action.yml:212`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`
- `action.yml:227`

### script-injection (severity: high)

Sub-rule (a): In .github/workflows/bump-runner-version.yml, `${{ github.event.inputs.version }}` is directly interpolated into a run: shell block in multiple places. For example: `if ! echo "${{ github.event.inputs.version }}" | grep -E ...`, `gh release view v${{ github.event.inputs.version }}`, and `VERSION="${{ github.event.inputs.version }}"`. A workflow_dispatch caller can supply a version string containing shell metacharacters (`;`, `|`, `$(...)`, etc.) to achieve command injection.

Locations:

- `.github/workflows/bump-runner-version.yml:24`
- `.github/workflows/bump-runner-version.yml:27`
- `.github/workflows/bump-runner-version.yml:28`
- `.github/workflows/bump-runner-version.yml:31`

### github-env-injection (severity: high)

In action.yml's 'Determine runner and kernel version' step, the value of `inputs.runner-version` is assigned to `RUNNER_VERSION` via direct expression interpolation (`RUNNER_VERSION="${{ inputs.runner-version }}"`), then written unsanitized to `$GITHUB_OUTPUT` with `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. Similarly, `inputs.mode` is used to compute `MODE_CACHE_KEY` via `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written to `$GITHUB_OUTPUT` with `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step, allowing a newline-injection attack to set arbitrary output variables.

Locations:

- `action.yml:113`
- `action.yml:114`
- `action.yml:117`
- `action.yml:118`

### unsafe-shell (severity: high)

In action.yml's 'Install CodSpeed runner' step, remote shell scripts are fetched and piped directly to bash without downloading to a file first. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when VERSION_TYPE is 'latest'); (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used when VERSION_TYPE is 'prerelease'). If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner.

Locations:

- `action.yml:148`
- `action.yml:155`

### unpinned-uses (severity: high)

Multiple `uses:` references in workflow files use mutable tag references instead of full 40-character SHA commit hashes. In .github/workflows/ci.yml: `actions/checkout@v4` appears in every job (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file). In .github/workflows/bump-runner-version.yml: `actions/checkout@v4`. Tags are mutable and can be moved to point to a different (potentially malicious) commit.

Locations:

- `.github/workflows/ci.yml:30`
- `.github/workflows/ci.yml:67`
- `.github/workflows/ci.yml:83`
- `.github/workflows/ci.yml:97`
- `.github/workflows/ci.yml:107`
- `.github/workflows/ci.yml:117`
- `.github/workflows/ci.yml:124`
- `.github/workflows/bump-runner-version.yml:18`

### missing-permissions (severity: medium)

The workflow file .github/workflows/ci.yml has no top-level `permissions:` key and none of its jobs (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file) define a job-level `permissions:` block. Without explicit permissions, the workflow inherits the default repository permissions, which may grant excessive access (e.g., write access to contents and pull-requests).

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

Fixed all findings across action.yml, .github/workflows/ci.yml, and .github/workflows/bump-runner-version.yml:

1. action.yml - 'Determine runner and kernel version' step: Moved ${{ inputs.runner-version }} and ${{ inputs.mode }} to env: block as INPUT_RUNNER_VERSION and INPUT_MODE. Added printf '%s' ... | tr -d '\n\r' sanitization before all GITHUB_OUTPUT writes.

2. action.yml - 'Install CodSpeed runner' step: Moved all ${{ steps.versions.outputs.* }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} to env: block. Fixed both curl|bash patterns by downloading to a temp file first (curl -fsSL <url> -o "$INSTALLER_TMP") then executing (bash "$INSTALLER_TMP" --quiet).

3. action.yml - 'Run the benchmarks' step: Moved all 11 ${{ inputs.* }} expressions to env: block (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG). All run: script references updated to use plain env vars.

4. .github/workflows/ci.yml: Added top-level 'permissions: contents: read'. Pinned all 7 occurrences of actions/checkout@v4 to actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.

5. .github/workflows/bump-runner-version.yml: Moved ${{ github.event.inputs.version }} to env: block as INPUT_VERSION. Updated all run: script references to use $INPUT_VERSION. Pinned actions/checkout@v4 to actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed three script injection vulnerabilities in hardened/action/.github/workflows/ci.yml. In each of the three affected steps (test-runner-version-formats job line ~68, test-go-runner-version-formats job line ~84, test-recent-pinned-runner-versions job line ~107), moved `${{ matrix.version }}` out of the `run:` shell string into a step-level `env:` block as `VERSION: ${{ matrix.version }}`, then replaced the inline expression with the safe shell variable reference `$VERSION`.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed four unquoted shell variable expansions in hardened/action/.github/workflows/bump-runner-version.yml: (1) `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`, (2) `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`, (3) `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`, (4) `--head $BRANCH_NAME` → `--head "$BRANCH_NAME"`. All variables derived from user input (github.event.inputs.version) are now properly double-quoted to prevent shell metacharacter interpretation.

