<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.2.1** was hardened automatically. 32 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ }} expressions are interpolated directly inside run: shell command strings across three steps in action.yml.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"`, `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`.

Step 4 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Step 5 ('Run the benchmarks'): `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `if [ "${{ inputs.cache-instruments }}" = "true" ]`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `if [ "${{ inputs.allow-empty }}" = "true" ]`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"`, `--cycle-estimation="${{ inputs.cycle-estimation }}"`, `--exclude-allocations="${{ inputs.exclude-allocations }}"`, `if [ "${{ inputs.simulation-track-subprocess }}" = "true" ]`. All of these allow an attacker-controlled value to be interpreted by the shell before quoting takes effect.

Locations:

- `action.yml:114`
- `action.yml:145`
- `action.yml:149`
- `action.yml:176`
- `action.yml:177`
- `action.yml:179`
- `action.yml:213`
- `action.yml:238`
- `action.yml:244`
- `action.yml:247`
- `action.yml:250`
- `action.yml:253`
- `action.yml:256`
- `action.yml:259`
- `action.yml:262`
- `action.yml:265`
- `action.yml:268`
- `action.yml:271`
- `action.yml:274`
- `action.yml:277`
- `action.yml:280`

### github-env-injection (severity: high)

Step 1 ('Determine runner and kernel version') writes values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization step (printf '%s' ... | tr -d '\n\r'):
- `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` where $RUNNER_VERSION is set from `${{ inputs.runner-version }}`
- `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` where $VERSION_TYPE is derived from the same input
- `echo "distro=$DISTRO" >> $GITHUB_OUTPUT` where $DISTRO can be set from `${{ runner.os }}`
- `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` where $MODE_CACHE_KEY is derived from `${{ inputs.mode }}`
A newline injected into any of these inputs could poison subsequent steps that read these outputs.

Locations:

- `action.yml:133`
- `action.yml:134`
- `action.yml:147`
- `action.yml:150`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content fetched via curl directly to bash in two code paths, without first saving to a file and verifying integrity:
1. Latest version path: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
2. Prerelease version path: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`
If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. (Note: the release/stable path correctly downloads to a temp file and verifies a SHA-256 hash before executing.)

Locations:

- `action.yml:188`
- `action.yml:194`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:116`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:283`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:284`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:296`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ }} expressions from run: blocks to env: blocks across all three affected steps. Step 1 now uses INPUT_RUNNER_VERSION, INPUT_MODE, RUNNER_OS env vars. Step 4 (Install) uses INPUT_RUNNER_VERSION, INPUT_VERSION_TYPE, INPUT_SKIP_HASH_CHECK_WARNING, INPUT_EXPECTED_HASH. Step 5 (Run benchmarks) uses 15 INPUT_* env vars for all inputs.

2. github-env-injection: All four values written to $GITHUB_OUTPUT in Step 1 are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing (runner-version, version-type, distro, mode-cache-key).

3. unsafe-shell: Replaced both `curl ... | bash -s -- --quiet` patterns (latest and prerelease paths) with download-then-execute: `curl -fsSL URL -o "$INSTALL_SCRIPT"` followed by `bash "$INSTALL_SCRIPT" --quiet`. The `--` was dropped as it was the shell's option terminator, not the script's argument.

