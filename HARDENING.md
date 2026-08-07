<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.0.3** was hardened automatically. 33 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Determine runner and kernel version' (run: block) directly interpolates ${{ inputs.runner-version }} and ${{ inputs.mode }} into shell commands. Rule (a): any ${{ }} expression inside a run: block is a script-injection risk because the value is substituted into the shell script before the shell parses it, allowing an attacker-controlled value to inject arbitrary shell commands. Offending lines include:
  RUNNER_VERSION="${{ inputs.runner-version }}"
  MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')

Locations:

- `action.yml:100`
- `action.yml:121`

### script-injection (severity: high)

Step 'Install CodSpeed runner' (run: block) directly interpolates ${{ steps.versions.outputs.runner-version }}, ${{ steps.versions.outputs.version-type }}, ${{ inputs.skip-hash-check-warning }}, and ${{ steps.installer-hash.outputs.hash }} into shell commands. Rule (a): these ${{ }} expressions are substituted into the shell script before the shell parses them, allowing injection of arbitrary shell commands. Offending lines include:
  RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
  VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
  SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
  EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"

Locations:

- `action.yml:131`
- `action.yml:132`
- `action.yml:134`
- `action.yml:175`

### script-injection (severity: high)

Step 'Run the benchmarks' (run: block) directly interpolates numerous ${{ inputs.* }} expressions into shell commands. Rule (a): these expressions are substituted into the shell script before the shell parses them, allowing an attacker-controlled input value to inject arbitrary shell commands. Offending lines include:
  if [ -z "${{ inputs.mode }}" ]
  if [ -n "${{ inputs.token }}" ]; then RUNNER_ARGS+=(--token "${{ inputs.token }}")
  RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")
  RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")
  RUNNER_ARGS+=(--mode="${{ inputs.mode }}")
  RUNNER_ARGS+=(--instruments="${{ inputs.instruments }}")
  RUNNER_ARGS+=(--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}")
  if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]
  RUNNER_ARGS+=(--setup-cache-dir="${{ inputs.instruments-cache-dir }}")
  if [ "${{ inputs.allow-empty }}" = "true" ]
  RUNNER_ARGS+=(--go-runner-version="${{ inputs.go-runner-version }}")
  RUNNER_ARGS+=(--config="${{ inputs.config }}")
  RUNNER_ARGS+=(--cycle-estimation="${{ inputs.cycle-estimation }}")
  RUNNER_ARGS+=(--exclude-allocations="${{ inputs.exclude-allocations }}")

Locations:

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
- `action.yml:230`
- `action.yml:233`
- `action.yml:236`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r'). Specifically:
1. ${{ inputs.runner-version }} is assigned to RUNNER_VERSION and then written: echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT — no newline sanitization.
2. ${{ inputs.mode }} is piped through 'tr \',\' \'-\'` (comma replacement only, not newline removal) and written: echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT — no newline sanitization.
An attacker can inject newlines into these inputs to poison subsequent GITHUB_OUTPUT entries.

Locations:

- `action.yml:113`
- `action.yml:114`
- `action.yml:121`
- `action.yml:122`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths without first downloading to a file:
1. Latest version path: curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet
2. Prerelease version path: curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet
This allows a compromised or MITM'd remote server to execute arbitrary code on the runner. The script should be downloaded to a temporary file, its integrity verified, and then executed separately.

Locations:

- `action.yml:155`
- `action.yml:161`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. script-injection & static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain env vars (INPUT_MODE, INPUT_TOKEN, RUNNER_VERSION, etc.).

2. github-env-injection: Added newline sanitization (printf '%s' "$VAR" | tr -d '\n\r') before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. unsafe-shell: Converted both curl-pipe-to-bash patterns (latest and prerelease paths) to download-then-execute pattern using mktemp temp files. Dropped the '--' shell option terminator as instructed (it was the shell's, not the script's). The release path already used download-then-execute and was left intact.

### Iteration 2

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

1. Pinned all 9 occurrences of `actions/checkout@v4` to SHA `11d5960a326750d5838078e36cf38b85af677262 # v4` across ci.yml (8 occurrences) and bump-runner-version.yml (1 occurrence). 2. Fixed script injection in bump-runner-version.yml by adding `INPUT_VERSION: ${{ github.event.inputs.version }}` to the step's `env:` block and replacing all inline `${{ github.event.inputs.version }}` references in the `run:` script with `$INPUT_VERSION` / `${INPUT_VERSION}`. 3. Fixed script injection in ci.yml for three `run:` blocks (test-runner-version-formats, test-go-runner-version-formats, test-recent-pinned-runner-versions) by adding `MATRIX_VERSION: ${{ matrix.version }}` to each step's `env:` block and replacing `${{ matrix.version }}` in the `run:` strings with `$MATRIX_VERSION`.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed four unquoted shell variable expansions in .github/workflows/bump-runner-version.yml: (1) `git checkout -b $BRANCH_NAME` → `git checkout -b "$BRANCH_NAME"`, (2) `echo $VERSION > .codspeed-runner-version` → `echo "$VERSION" > .codspeed-runner-version`, (3) `git push origin $BRANCH_NAME` → `git push origin "$BRANCH_NAME"`, (4) `gh pr create ... --head $BRANCH_NAME` → `gh pr create ... --head "$BRANCH_NAME"`. The INPUT_VERSION value was already correctly placed in the env block rather than directly interpolated via ${{ }} expressions in the run script.

