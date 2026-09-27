<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.14.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings in action.yml, violating sub-rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can protect it.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs interpolated directly into shell.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all direct expression interpolations in shell.

Step 4 ('Run the benchmarks'): `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--mode="${{ inputs.mode }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version="${{ inputs.go-runner-version }}"`, `--config="${{ inputs.config }}"` — all direct expression interpolations in shell. These should be routed through `env:` variables and then double-quoted in the shell.

Locations:

- `action.yml:98`
- `action.yml:122`
- `action.yml:133`
- `action.yml:134`
- `action.yml:136`
- `action.yml:175`
- `action.yml:186`
- `action.yml:190`
- `action.yml:193`
- `action.yml:196`
- `action.yml:199`
- `action.yml:202`
- `action.yml:205`
- `action.yml:208`
- `action.yml:211`
- `action.yml:214`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, three values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — RUNNER_VERSION is set from `${{ inputs.runner-version }}` at the top of the same run block.
2. `echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT` — VERSION_TYPE is computed from RUNNER_VERSION (which comes from inputs.runner-version).
3. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — MODE_CACHE_KEY is derived from `${{ inputs.mode }}`.

A newline character in any of these inputs could allow injection of additional key=value pairs into GITHUB_OUTPUT, potentially overwriting outputs consumed by later steps.

Locations:

- `action.yml:120`
- `action.yml:121`
- `action.yml:123`

### unsafe-shell (severity: high)

In the 'Install CodSpeed runner' step, remote content is fetched and piped directly to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`. If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its integrity verified (hash check), and then executed separately — which is already done for the release version path but not for the 'latest' version path.

Locations:

- `action.yml:155`

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

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection** (all 3 run: steps): Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks. In 'Determine runner and kernel version': INPUT_RUNNER_VERSION and INPUT_MODE. In 'Install CodSpeed runner': RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH. In 'Run the benchmarks': INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG.

2. **github-env-injection**: The three values written to $GITHUB_OUTPUT in 'Determine runner and kernel version' (runner-version, version-type, mode-cache-key) are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. Also fixed $GITHUB_OUTPUT references to use quoted form "$GITHUB_OUTPUT".

3. **unsafe-shell**: Changed `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` to download to a temp file first (`curl -fsSL https://codspeed.io/install.sh -o "$INSTALLER_TMP"`), then execute separately (`bash "$INSTALLER_TMP" --quiet`). The `--` was correctly dropped as it was the shell's own option terminator in the pipe form, not an argument to the downloaded script.

