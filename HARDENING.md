<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.1** was hardened automatically. 30 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are interpolated directly inside `run:` shell command strings in action.yml. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are embedded directly in the shell. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are all interpolated directly. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell commands. An attacker-controlled input value containing shell metacharacters (e.g. `"; malicious_cmd; "`) would be executed by the shell.

Locations:

- `action.yml:95`
- `action.yml:122`
- `action.yml:152`
- `action.yml:153`
- `action.yml:154`
- `action.yml:196`
- `action.yml:205`
- `action.yml:210`
- `action.yml:215`
- `action.yml:220`
- `action.yml:225`
- `action.yml:230`
- `action.yml:235`
- `action.yml:240`
- `action.yml:245`
- `action.yml:250`

### script-injection (severity: high)

Rule (a): `${{ github.event.inputs.version }}` is interpolated directly inside `run:` shell commands in the 'Bump' step of bump-runner-version.yml. This workflow_dispatch input is user-controlled and is embedded in shell commands including `echo "${{ github.event.inputs.version }}" | grep -E ...`, `gh release view v${{ github.event.inputs.version }} ...`, and `VERSION="${{ github.event.inputs.version }}"`. A malicious value could inject arbitrary shell commands.

Locations:

- `.github/workflows/bump-runner-version.yml:22`
- `.github/workflows/bump-runner-version.yml:27`
- `.github/workflows/bump-runner-version.yml:28`
- `.github/workflows/bump-runner-version.yml:31`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step of action.yml, `RUNNER_VERSION` is derived from `${{ inputs.runner-version }}` (an untrusted input) and then written to `$GITHUB_OUTPUT` via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). Similarly, `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` and written to `$GITHUB_OUTPUT` via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without sanitization. A newline character in either input could inject additional key=value pairs into the GitHub output context.

Locations:

- `action.yml:117`
- `action.yml:122`

### unsafe-shell (severity: high)

Two `curl ... | bash` patterns exist in the 'Install CodSpeed runner' step of action.yml. When `VERSION_TYPE` is `latest`, the script runs `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`, and when `VERSION_TYPE` is `prerelease`, it runs `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`. In both cases, remote content is piped directly to bash without downloading to a file first for verification. This means a compromised or MITM'd response would execute arbitrary code immediately.

Locations:

- `action.yml:168`
- `action.yml:176`

### unpinned-uses (severity: high)

Multiple `uses:` references in ci.yml and bump-runner-version.yml use mutable tag references instead of full 40-character commit SHAs. In ci.yml: `actions/checkout@v4` appears in jobs test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, and test-config-file. In bump-runner-version.yml: `actions/checkout@v4` is used. These tag-pinned references can be silently updated by the upstream repository owner, enabling supply-chain attacks.

Locations:

- `.github/workflows/ci.yml:30`
- `.github/workflows/ci.yml:60`
- `.github/workflows/ci.yml:80`
- `.github/workflows/ci.yml:95`
- `.github/workflows/ci.yml:110`
- `.github/workflows/ci.yml:122`
- `.github/workflows/ci.yml:131`
- `.github/workflows/bump-runner-version.yml:16`

### missing-permissions (severity: medium)

The workflow file ci.yml has no top-level `permissions:` key and none of its jobs (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file) define a `permissions:` block. This means the workflow runs with the default GitHub token permissions, which may be broader than necessary (e.g., write access to contents and packages on some repository configurations).

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

1. script-injection / static-inline-injection (action.yml): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in 'Determine runner and kernel version' (INPUT_RUNNER_VERSION, INPUT_MODE), 'Install CodSpeed runner' (RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH), and 'Run the benchmarks' (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG).

2. script-injection (bump-runner-version.yml): Moved ${{ github.event.inputs.version }} to env: block as INPUT_VERSION; updated all shell references.

3. github-env-injection (action.yml): Added printf '%s' ... | tr -d '\n\r' sanitization before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

4. unsafe-shell (action.yml): Replaced both curl|bash patterns (for 'latest' and 'prerelease' version types) with download-to-tempfile-then-execute pattern.

5. unpinned-uses: Pinned all 8 actions/checkout@v4 references to SHA 11d5960a326750d5838078e36cf38b85af677262 # v4.

6. missing-permissions (ci.yml): Added top-level 'permissions: contents: read' block.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed four unquoted variable expansions in .github/workflows/bump-runner-version.yml that could allow shell metacharacter injection from the user-controlled `github.event.inputs.version` input. Added double quotes around: `$BRANCH_NAME` in `git checkout -b`, `$VERSION` in `echo ... > .codspeed-runner-version`, `$BRANCH_NAME` in `git push origin`, and `$BRANCH_NAME` in `gh pr create --head`. The input is already routed through an env var (INPUT_VERSION) and validated against a semver regex, but the unquoted expansions still posed an injection risk.

