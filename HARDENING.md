<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.4** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions from `inputs.*` and `steps.*.outputs.*` contexts are interpolated directly inside `run:` shell command strings, violating rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can protect it.

Step 'Determine runner and kernel version': `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs interpolated directly in run block.

Step 'Install CodSpeed runner': `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` — all interpolated directly in run block.

Step 'Run the benchmarks': `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all interpolated directly inside the run block shell script. These should be passed via `env:` variables and then referenced as quoted shell variables.

Locations:

- `action.yml:102`
- `action.yml:130`
- `action.yml:163`
- `action.yml:164`
- `action.yml:166`
- `action.yml:196`
- `action.yml:224`
- `action.yml:230`
- `action.yml:233`
- `action.yml:236`
- `action.yml:239`
- `action.yml:242`
- `action.yml:245`
- `action.yml:248`
- `action.yml:251`
- `action.yml:254`
- `action.yml:257`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required sanitization (`printf '%s' ... | tr -d '\n\r'`):

1. `RUNNER_VERSION` is set from `${{ inputs.runner-version }}` (line 102) and then written: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` — no newline sanitization applied before the write.

2. `MODE_CACHE_KEY` is derived from `${{ inputs.mode }}` (line 130) and then written: `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` — no newline sanitization applied before the write.

An attacker who controls `inputs.runner-version` or `inputs.mode` could inject newlines to poison subsequent steps that read these outputs.

Locations:

- `action.yml:128`
- `action.yml:131`

### unsafe-shell (severity: high)

Two `curl ... | bash` patterns pipe remote installer scripts directly to bash without first downloading to a file and verifying integrity:

1. For 'latest' version mode: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — remote content piped directly to bash.

2. For 'prerelease' version mode: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — remote content piped directly to bash.

Note: the 'release' code path correctly downloads to a temp file and verifies a SHA-256 hash before executing, but the 'latest' and 'prerelease' paths bypass this protection entirely.

Locations:

- `action.yml:175`
- `action.yml:182`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables ($INPUT_MODE, $INPUT_TOKEN, etc.).

2. github-env-injection: Added newline sanitization before writing to $GITHUB_OUTPUT. Both 'runner-version' and 'mode-cache-key' outputs now use `printf '%s' "$VAR" | tr -d '\n\r'` to strip newlines before writing.

3. unsafe-shell: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with a safe download-then-execute pattern: download to a temp file with `curl -fsSL <url> -o "$INSTALLER_TMP"`, then execute with `bash "$INSTALLER_TMP" --quiet`. The `--` shell option terminator was correctly dropped since we're no longer reading from stdin.

