<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.2** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml.

1. Step 'Determine runner and kernel version': `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled inputs are expanded directly into the shell before quoting can protect them.

2. Step 'Install CodSpeed runner': `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` are all directly interpolated into the run: script.

3. Step 'Run the benchmarks': Numerous `${{ inputs.* }}` expressions (inputs.mode, inputs.token, inputs.working-directory, inputs.upload-url, inputs.instruments, inputs.mongo-uri-env-name, inputs.cache-instruments, inputs.instruments-cache-dir, inputs.allow-empty, inputs.go-runner-version, inputs.config) are directly interpolated into shell conditionals and array assignments, allowing shell metacharacter injection.

Locations:

- `action.yml:97`
- `action.yml:131`
- `action.yml:163`
- `action.yml:165`
- `action.yml:167`
- `action.yml:218`
- `action.yml:228`
- `action.yml:234`
- `action.yml:238`
- `action.yml:242`
- `action.yml:246`
- `action.yml:250`
- `action.yml:254`
- `action.yml:258`
- `action.yml:262`
- `action.yml:266`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (direct expression interpolation) and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'` (the tr only strips commas, not newlines) and then written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline in inputs.mode would survive the tr and inject into GITHUB_OUTPUT.

Locations:

- `action.yml:97`
- `action.yml:126`
- `action.yml:131`
- `action.yml:133`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:

1. Latest version path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the install script is fetched and executed in a single pipeline with no hash verification.

2. Prerelease version path: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions, also without hash verification.

Note: the release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths do not.

Locations:

- `action.yml:178`
- `action.yml:186`

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

Fixed all findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': moved inputs.runner-version → INPUT_RUNNER_VERSION, inputs.mode → INPUT_MODE
   - 'Install CodSpeed runner': moved steps.versions.outputs.runner-version → RUNNER_VERSION, steps.versions.outputs.version-type → VERSION_TYPE, inputs.skip-hash-check-warning → SKIP_HASH_CHECK_WARNING, steps.installer-hash.outputs.hash → EXPECTED_HASH
   - 'Run the benchmarks': moved all 11 inputs to env: block (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG)

2. github-env-injection: Added sanitization using `printf '%s' "$VAR" | tr -d '\n\r'` before writing runner-version, version-type, and mode-cache-key to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed both curl-pipe-to-bash patterns in 'Install CodSpeed runner':
   - Latest path: curl downloads to temp file, then bash executes the file (dropping the shell's '--' option terminator)
   - Prerelease path: same pattern applied

