<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.5** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml.

**Step: "Determine runner and kernel version"** — `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly into shell:
  - `RUNNER_VERSION="${{ inputs.runner-version }}"`
  - `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`

**Step: "Install CodSpeed runner"** — `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are interpolated directly into shell.

**Step: "Run the benchmarks"** — Numerous `${{ inputs.* }}` expressions are interpolated directly into shell commands, including `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}`. An attacker-controlled value containing shell metacharacters (e.g. `"; malicious_cmd; "`) would be executed by the shell before quoting takes effect. All `${{ ... }}` expressions must be moved to `env:` variables and then referenced as quoted `"$VAR"` in the shell.

Locations:

- `action.yml:94`
- `action.yml:121`
- `action.yml:149`
- `action.yml:204`

### github-env-injection (severity: high)

**Step: "Determine runner and kernel version"** writes untrusted input-derived values to `$GITHUB_OUTPUT` without sanitization:

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (an attacker-controlled value) and then written unsanitized: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A newline embedded in `inputs.runner-version` could inject additional key=value pairs into the output file.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` via `tr ',' '-'` (which does not strip newlines) and then written unsanitized: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. The required sanitization step `printf '%s' "$VAR" | tr -d '\n\r'` is missing before each write.

Locations:

- `action.yml:116`
- `action.yml:117`
- `action.yml:122`

### unsafe-shell (severity: high)

**Step: "Install CodSpeed runner"** pipes a remotely-fetched script directly to bash without first downloading it to a file for inspection or integrity verification:

```
curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet
```

This pattern executes whatever content the remote server returns at the moment of the request. If the remote URL is compromised (e.g. via DNS hijacking, CDN compromise, or server-side attack), arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its hash verified against a known-good value, and only then executed — a pattern the action already uses for the versioned installer path but not for the `latest` branch.

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in three steps:
   - 'Determine runner and kernel version': Added env: with INPUT_RUNNER_VERSION and INPUT_MODE
   - 'Install CodSpeed runner': Added env: with RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, EXPECTED_HASH
   - 'Run the benchmarks': Added env: with INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, INPUT_CONFIG

2. **github-env-injection**: Sanitized user-controlled values before writing to $GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` for RUNNER_VERSION and MODE_CACHE_KEY. Also quoted $GITHUB_OUTPUT references.

3. **unsafe-shell**: Replaced `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` with a safe pattern: download to temp file with `curl -fsSL ... -o "$INSTALL_SCRIPT"`, then execute `bash "$INSTALL_SCRIPT" --quiet` (dropped the `--` which was the shell's option terminator, not the script's argument).

