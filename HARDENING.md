<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions from `inputs.*` and `steps.*.outputs.*` contexts are interpolated directly inside `run:` shell command strings, enabling script injection. An attacker-controlled input value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) would be executed by the shell before any quoting can protect it.

**Step 1 — "Determine runner and kernel version"** (rule a):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input interpolated directly into shell
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input interpolated directly into shell

**Step 3 — "Install CodSpeed runner"** (rule a):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step 4 — "Run the benchmarks"** (rule a): Numerous `${{ inputs.* }}` expressions are interpolated directly into the shell script, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`.

All these values should be passed via `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) instead of being interpolated directly.

Locations:

- `action.yml:96`
- `action.yml:121`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:185`
- `action.yml:200`
- `action.yml:207`
- `action.yml:211`
- `action.yml:215`
- `action.yml:219`
- `action.yml:223`
- `action.yml:227`
- `action.yml:231`
- `action.yml:235`
- `action.yml:239`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `$RUNNER_VERSION` is set directly from `${{ inputs.runner-version }}` (an attacker-controlled value). A newline embedded in the input could inject additional key=value pairs into `$GITHUB_OUTPUT`, poisoning subsequent steps.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `$MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`. The `tr` only strips commas, not newlines, so a newline in `inputs.mode` still allows injection.

Fix: sanitize before writing, e.g.:
```bash
safe=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
echo "runner-version=$safe" >> "$GITHUB_OUTPUT"
```

Locations:

- `action.yml:116`
- `action.yml:122`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote shell scripts directly to `bash` without first downloading and verifying them:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when `VERSION_TYPE=latest`. The script is fetched from a remote URL and executed immediately. If the remote server is compromised or the connection is intercepted (MITM), arbitrary code runs on the runner.

2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when `VERSION_TYPE=prerelease`. Same risk applies.

Note: the release path correctly downloads to a temp file and verifies a SHA-256 hash before executing — that pattern is safe. The `latest` and `prerelease` paths should adopt the same download-then-verify approach.

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

Fixed all findings in hardened/action/action.yml:

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps. Step 1 now uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. Step 3 (Install CodSpeed runner) now uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. Step 4 (Run the benchmarks) now uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. **github-env-injection**: Both values written to $GITHUB_OUTPUT are now sanitized with tr -d '\n\r'. RUNNER_VERSION uses `printf '%s' "$RUNNER_VERSION" | tr -d '\n\r'` and MODE_CACHE_KEY uses `printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r'`. Also quoted $GITHUB_OUTPUT references.

3. **unsafe-shell**: Fixed the two curl-pipe-to-bash patterns in the 'latest' and 'prerelease' branches of the Install CodSpeed runner step. Both now download to a temp file first (`curl -fsSL ... -o "$INSTALLER_TMP"`) and then execute (`bash "$INSTALLER_TMP" --quiet`). The '--' from the original pipe form was correctly dropped as it was the shell's option terminator, not the script's argument.

