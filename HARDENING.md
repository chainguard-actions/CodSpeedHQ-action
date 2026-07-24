<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.1** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions are interpolated directly inside `run:` shell command strings across three steps.

**Step 1 – "Determine runner and kernel version"**: `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input values are substituted into the shell before it runs.

**Step 3 – "Install CodSpeed runner"**: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly into the shell.

**Step 4 – "Run the benchmarks"**: `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly into the shell. A calling workflow can supply values containing shell metacharacters (`;`, `|`, `$(...)`, etc.) to achieve arbitrary command execution.

Locations:

- `action.yml:105`
- `action.yml:135`
- `action.yml:155`
- `action.yml:156`
- `action.yml:158`
- `action.yml:196`
- `action.yml:210`
- `action.yml:215`
- `action.yml:218`
- `action.yml:221`
- `action.yml:224`
- `action.yml:227`
- `action.yml:230`
- `action.yml:233`
- `action.yml:236`
- `action.yml:239`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two untrusted input values are written to `$GITHUB_OUTPUT` without the required `printf '%s' ... | tr -d '\n\r'` sanitization:

1. `${{ inputs.runner-version }}` is interpolated into the shell as `RUNNER_VERSION`, manipulated, and then written via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline embedded in the input can inject additional key=value pairs into GITHUB_OUTPUT.

2. `${{ inputs.mode }}` is piped through `tr ',' '-'` (which removes commas but NOT newlines or carriage returns) and the result is written via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The `tr ',' '-'` step is insufficient sanitization — embedded `\n` or `\r` characters still allow injection of additional entries into GITHUB_OUTPUT.

Locations:

- `action.yml:105`
- `action.yml:130`
- `action.yml:135`
- `action.yml:136`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to bash in two code paths, without first downloading to a file and verifying integrity:

1. **Latest version path**: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the install script is fetched from a mutable URL and executed immediately. If the remote server is compromised or the URL is hijacked, arbitrary code runs on the runner.

2. **Prerelease version path**: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions. Note that the release version path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but these two paths bypass that protection entirely.

Locations:

- `action.yml:163`
- `action.yml:170`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks across all three affected steps:
   - Step 1 (Determine runner and kernel version): Added env: block with INPUT_RUNNER_VERSION and INPUT_MODE; shell script now uses $INPUT_RUNNER_VERSION and $INPUT_MODE.
   - Step 3 (Install CodSpeed runner): Added env: block with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH; removed all inline ${{ }} from the run: script.
   - Step 4 (Run the benchmarks): Added env: block with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG; all references in the run: script now use plain env vars.

2. **github-env-injection**: Added `tr -d '\n\r'` sanitization for values written to $GITHUB_OUTPUT:
   - runner-version: `safe_runner_version=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')` before writing.
   - mode-cache-key: `MODE_CACHE_KEY=$(printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r')` — now also strips newlines in addition to replacing commas.

3. **unsafe-shell**: Replaced both `curl | bash` patterns with download-to-temp-file-then-execute:
   - Latest version: `curl -fsSL -o "$INSTALLER_TMP" https://codspeed.io/install.sh` then `bash "$INSTALLER_TMP" --quiet`
   - Prerelease version: `curl -fsSL -o "$INSTALLER_TMP" "https://codspeed.io/v$RUNNER_VERSION/install.sh"` then `bash "$INSTALLER_TMP" --quiet`

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all 5 findings across 2 workflow files:

1. bump-runner-version.yml - script-injection: Moved `${{ github.event.inputs.version }}` into the step env block as INPUT_VERSION; replaced all 3 shell interpolations with $INPUT_VERSION.

2. ci.yml - script-injection: Removed `${{ matrix.version }}` from all 3 run: shell blocks (test-runner-version-formats, test-go-runner-version-formats, test-recent-pinned-runner-versions). The run: strings now use static echo messages; matrix.version still flows through name: and with: fields which are not shell-executed.

3. ci.yml - unpinned-uses: Pinned all 7 occurrences of actions/checkout@v4 to actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.

4. bump-runner-version.yml - unpinned-uses: Pinned actions/checkout@v4 to actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.

5. ci.yml - missing-permissions: Added top-level `permissions: contents: read` block.

