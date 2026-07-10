<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 30 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ inputs.* }} expressions are directly interpolated inside run: shell commands in action.yml. In the 'Determine runner and kernel version' step, `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly. In the 'Install CodSpeed runner' step, `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are interpolated directly. In the 'Run the benchmarks' step, `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into shell commands. These allow an attacker to inject arbitrary shell commands via crafted input values.

Locations:

- `action.yml:96`
- `action.yml:120`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:175`

### script-injection (severity: high)

Sub-rule (a): In .github/workflows/bump-runner-version.yml, `${{ github.event.inputs.version }}` (a workflow_dispatch user-controlled input) is directly interpolated inside a run: shell command at multiple points: `echo "${{ github.event.inputs.version }}"`, `gh release view v${{ github.event.inputs.version }}`, and `VERSION="${{ github.event.inputs.version }}"`. An attacker with workflow_dispatch access can inject arbitrary shell commands.

Locations:

- `.github/workflows/bump-runner-version.yml:24`
- `.github/workflows/bump-runner-version.yml:28`
- `.github/workflows/bump-runner-version.yml:33`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, remote scripts are downloaded and piped directly to bash without prior hash verification: (1) `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` when VERSION_TYPE=latest, and (2) `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` when VERSION_TYPE=prerelease. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner.

Locations:

- `action.yml:161`
- `action.yml:168`

### unpinned-uses (severity: high)

Multiple uses: references in workflow files use mutable tags instead of full 40-character SHA commit hashes. In ci.yml: `actions/checkout@v4` (used 6 times). In bump-runner-version.yml: `actions/checkout@v4`. These tag-based references can be silently redirected to different (potentially malicious) commits.

Locations:

- `.github/workflows/ci.yml:19`
- `.github/workflows/bump-runner-version.yml:17`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step of action.yml, untrusted input values are written to $GITHUB_OUTPUT without the required sanitization (`printf '%s' ... | tr -d '\n\r'`). Specifically: (1) `${{ inputs.runner-version }}` is assigned to RUNNER_VERSION and then written as `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` without newline stripping; (2) `${{ inputs.mode }}` is used in `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` and then written as `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` without newline stripping. A newline in these values can inject additional key=value pairs into GITHUB_OUTPUT, potentially overwriting other outputs.

Locations:

- `action.yml:104`
- `action.yml:120`

### permissions (severity: medium)

The workflow file ci.yml has no top-level `permissions:` key and none of its jobs (test-action, test-runner-version-formats, test-go-runner-version-formats, get-recent-pinned-runner-versions, test-recent-pinned-runner-versions, check-installer-hashes, test-config-file) define a job-level `permissions:` block. This means the workflow runs with the default (potentially broad) GITHUB_TOKEN permissions.

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell, unpinned-uses, permissions

**Notes:**

Fixed all findings across action.yml, .github/workflows/bump-runner-version.yml, and .github/workflows/ci.yml: (1) script-injection/static-inline-injection: moved all ${{ inputs.* }} expressions in action.yml run: blocks to env: maps (INPUT_RUNNER_VERSION, INPUT_MODE, RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, INSTALLER_HASH, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG); moved ${{ github.event.inputs.version }} to INPUT_VERSION env var in bump-runner-version.yml; (2) github-env-injection: sanitized RUNNER_VERSION and MODE_CACHE_KEY with printf '%s' ... | tr -d '\n\r' before writing to GITHUB_OUTPUT; (3) unsafe-shell: replaced curl | bash patterns with download-to-tempfile then execute for both latest and prerelease installer cases; (4) unpinned-uses: pinned all actions/checkout@v4 references to full SHA 34e114876b0b11c390a56381ad16ebd13914f8d5 in ci.yml and bump-runner-version.yml; (5) permissions: added top-level permissions: contents: read to ci.yml.

