<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.0** was hardened automatically. 30 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ inputs.* }} expressions are interpolated directly inside run: shell command strings in action.yml. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` is directly embedded in the shell script. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are all directly interpolated. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all directly interpolated into shell commands. An attacker-controlled input value containing shell metacharacters (e.g. `$(cmd)`, `;`, `|`) would be executed by the shell before quoting can protect it.

Locations:

- `action.yml:96`
- `action.yml:131`
- `action.yml:147`
- `action.yml:172`
- `action.yml:196`

### script-injection (severity: high)

Sub-rule (a): In .github/workflows/bump-runner-version.yml, `${{ github.event.inputs.version }}` (a workflow_dispatch user-controlled input) is interpolated directly inside the run: shell script multiple times — e.g. `echo "${{ github.event.inputs.version }}" | grep -E ...` and `gh release view v${{ github.event.inputs.version }}`. A malicious version string containing shell metacharacters would be executed by the shell.

Locations:

- `.github/workflows/bump-runner-version.yml:22`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step of action.yml, the untrusted input `${{ inputs.runner-version }}` is interpolated directly into the shell variable RUNNER_VERSION, which is then written to $GITHUB_OUTPUT without sanitization: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. Similarly, `${{ inputs.mode }}` is used to compute MODE_CACHE_KEY (via `echo "${{ inputs.mode }}" | tr ',' '-'`) and then written to $GITHUB_OUTPUT: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. Neither write is preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline character in the input could inject arbitrary key=value pairs into the GitHub Actions output context.

Locations:

- `action.yml:118`
- `action.yml:124`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step of action.yml, remote shell scripts are fetched and piped directly to bash without downloading to a file first. Two occurrences: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (for 'latest' version type) and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (for 'prerelease' version type). If the remote server is compromised or the URL is intercepted, arbitrary code will execute on the runner.

Locations:

- `action.yml:153`
- `action.yml:160`

### unpinned-uses (severity: high)

Both workflow files use `actions/checkout@v4` — a mutable tag reference rather than a pinned 40-character commit SHA. If the tag is moved (e.g. by a supply-chain attack on the actions/checkout repository), the workflow will silently execute different code. All `uses:` references in .github/workflows/ should be pinned to full SHA digests (e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`).

Locations:

- `.github/workflows/ci.yml:27`
- `.github/workflows/bump-runner-version.yml:18`

### missing-permissions (severity: medium)

The workflow file ci.yml has no top-level `permissions:` key and none of its jobs (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file) define a job-level `permissions:` block. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to contents, packages, etc.).

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell, unpinned-uses, missing-permissions

**Notes:**

Fixed all findings across action.yml, .github/workflows/ci.yml, and .github/workflows/bump-runner-version.yml:

1. action.yml - 'Determine runner and kernel version' step: Moved ${{ inputs.runner-version }} and ${{ inputs.mode }} to env: block as INPUT_RUNNER_VERSION and INPUT_MODE. All GITHUB_OUTPUT writes now use printf '%s' ... | tr -d '\n\r' sanitization.

2. action.yml - 'Install CodSpeed runner' step: Moved ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} to env: block. Fixed two curl|bash patterns (latest and prerelease) to download to a temp file first then execute.

3. action.yml - 'Run the benchmarks' step: Moved all 11 ${{ inputs.* }} expressions (${{ inputs.mode }}, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config) to env: block with INPUT_* names. Shell script now uses $INPUT_* variables.

4. .github/workflows/bump-runner-version.yml: Moved ${{ github.event.inputs.version }} to env: block as INPUT_VERSION. All shell references updated to use $INPUT_VERSION. Pinned actions/checkout@v4 to SHA 11d5960a326750d5838078e36cf38b85af677262.

5. .github/workflows/ci.yml: Added top-level 'permissions: contents: read'. Pinned all 7 occurrences of actions/checkout@v4 to SHA 11d5960a326750d5838078e36cf38b85af677262.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed three unquoted variable expansions in .github/workflows/bump-runner-version.yml: (1) `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`, (2) `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`, (3) `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`. Also fixed the unquoted `--head $BRANCH_NAME` in the `gh pr create` command for completeness. All other variable uses ($VERSION in commit messages, etc.) were already properly quoted.

