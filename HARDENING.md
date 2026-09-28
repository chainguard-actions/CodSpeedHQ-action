<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell blocks in action.yml, allowing an attacker-controlled value to be injected into the shell before it is executed.

**Step: "Determine runner and kernel version"** (line ~100):
- `RUNNER_VERSION="${{ inputs.runner-version }}"` — attacker-controlled input interpolated directly into shell.
- `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — attacker-controlled input interpolated directly into shell.

**Step: "Install CodSpeed runner"** (line ~151):
- `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`
- `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`
- `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`
- `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`

**Step: "Run the benchmarks"** (line ~222):
- `if [ -z "${{ inputs.mode }}" ]`
- `if [ -n "${{ inputs.token }}" ]` / `--token "${{ inputs.token }}"`
- `--working-directory="${{ inputs.working-directory }}"`
- `--upload-url="${{ inputs.upload-url }}"`
- `--mode="${{ inputs.mode }}"`
- `--instruments="${{ inputs.instruments }}"`
- `--mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"`
- `if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]`
- `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`
- `if [ "${{ inputs.allow-empty }}" = "true" ]`
- `--go-runner-version="${{ inputs.go-runner-version }}"`
- `--config="${{ inputs.config }}"`

All of these should be moved to `env:` variables and referenced as `"$VAR"` in the shell.

Locations:

- `action.yml:100`
- `action.yml:133`
- `action.yml:151`
- `action.yml:152`
- `action.yml:154`
- `action.yml:196`
- `action.yml:222`
- `action.yml:228`

### github-env-injection (severity: high)

In the "Determine runner and kernel version" step, two values derived from untrusted inputs are written to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — `RUNNER_VERSION` is set directly from `${{ inputs.runner-version }}` on the previous line. A newline embedded in the input value could inject additional key=value pairs into GITHUB_OUTPUT.

2. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `echo "${{ inputs.mode }}" | tr ',' '-'`. The `tr` only removes commas, not newlines, so a newline in `inputs.mode` can still inject additional entries.

Fix: sanitize before writing, e.g.:
```bash
safe=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
echo "runner-version=$safe" >> "$GITHUB_OUTPUT"
```

Locations:

- `action.yml:125`
- `action.yml:134`

### unsafe-shell (severity: high)

The "Install CodSpeed runner" step pipes remote content directly to `bash` in two code paths, without downloading to a file first and verifying integrity:

1. **Latest version path** (line ~160): `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — the remote install script is fetched and executed in a single pipeline with no hash verification.

2. **Prerelease version path** (line ~167): `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — same pattern for prerelease versions, also without hash verification.

If the remote server or network is compromised, arbitrary code can be executed on the runner. The release-version code path correctly downloads to a temp file and verifies a SHA-256 hash before executing — the same pattern should be applied to all paths.

Locations:

- `action.yml:160`
- `action.yml:167`

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

1. **script-injection / static-inline-injection** (all 27 instances): Moved all `${{ inputs.* }}` and `${{ steps.*.outputs.* }}` expressions from `run:` shell blocks into `env:` blocks. Three steps were updated:
   - 'Determine runner and kernel version': Added `env: INPUT_RUNNER_VERSION / INPUT_MODE`, replaced inline expressions with `$INPUT_RUNNER_VERSION` and `$INPUT_MODE`.
   - 'Install CodSpeed runner': Added `env: RUNNER_VERSION / VERSION_TYPE / SKIP_HASH_CHECK_WARNING / EXPECTED_HASH`, removed all inline `${{ }}` from the shell script.
   - 'Run the benchmarks': Added 11 env vars (INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG), replaced all inline expressions with `$VAR_NAME` references.

2. **github-env-injection**: Sanitized RUNNER_VERSION and MODE_CACHE_KEY before writing to $GITHUB_OUTPUT using `printf '%s' ... | tr -d '\n\r'`.

3. **unsafe-shell**: Replaced `curl ... | bash -s -- --quiet` with download-then-execute pattern for both 'latest' and 'prerelease' paths. The `--` was dropped (it was the shell's option terminator, not the script's argument). Each path now uses `mktemp` + `curl -o` + `bash file --quiet`.

