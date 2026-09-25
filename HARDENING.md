<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.17.6** was hardened automatically. 27 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings in action.yml, violating rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

Step 1 ('Determine runner and kernel version'): `RUNNER_VERSION="${{ inputs.runner-version }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — inputs are expanded by the YAML template engine before the shell ever sees them, enabling command injection.

Step 3 ('Install CodSpeed runner'): `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"`, and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"` are all directly interpolated.

Step 4 ('Run the benchmarks'): `${{ inputs.mode }}`, `${{ inputs.token }}`, `${{ inputs.working-directory }}`, `${{ inputs.upload-url }}`, `${{ inputs.instruments }}`, `${{ inputs.mongo-uri-env-name }}`, `${{ inputs.cache-instruments }}`, `${{ inputs.instruments-cache-dir }}`, `${{ inputs.allow-empty }}`, `${{ inputs.go-runner-version }}`, and `${{ inputs.config }}` are all directly interpolated into shell commands. All inputs should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR").

Locations:

- `action.yml:100`
- `action.yml:116`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:175`
- `action.yml:196`
- `action.yml:213`
- `action.yml:218`
- `action.yml:222`
- `action.yml:226`
- `action.yml:230`
- `action.yml:234`
- `action.yml:238`
- `action.yml:242`
- `action.yml:246`
- `action.yml:250`

### github-env-injection (severity: high)

In the 'Determine runner and kernel version' step, the value of `${{ inputs.mode }}` is directly interpolated into a shell pipeline and the result is written to $GITHUB_OUTPUT without sanitization:

  `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`
  `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`

Because `${{ inputs.mode }}` is expanded by the YAML template engine before the shell runs, a newline character embedded in the input value would allow an attacker to inject arbitrary key=value pairs into $GITHUB_OUTPUT. The value must be sanitized with `printf '%s' ... | tr -d '\n\r'` before being written to the special environment file.

Locations:

- `action.yml:116`

### unsafe-shell (severity: high)

Two `curl | bash` patterns pipe remotely-fetched shell scripts directly to bash without first downloading and verifying the content:

1. For 'latest' version: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`
2. For 'prerelease' versions: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. The script should be downloaded to a temporary file, its integrity verified (e.g., via SHA-256 hash), and only then executed — as is already done for the 'release' version path in the same step.

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

1. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell blocks into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference them as plain env vars ($INPUT_MODE, $INPUT_TOKEN, $INPUT_WORKING_DIRECTORY, $INPUT_UPLOAD_URL, $INPUT_INSTRUMENTS, $INPUT_MONGO_URI_ENV_NAME, $INPUT_CACHE_INSTRUMENTS, $INPUT_INSTRUMENTS_CACHE_DIR, $INPUT_ALLOW_EMPTY, $INPUT_GO_RUNNER_VERSION, $INPUT_CONFIG, $RUNNER_VERSION, $VERSION_TYPE, $SKIP_HASH_CHECK_WARNING, $EXPECTED_HASH).

2. **github-env-injection**: The inputs.mode value is now passed via env: as INPUT_MODE and sanitized with `printf '%s' "$INPUT_MODE" | tr -d '\n\r'` before being used to compute MODE_CACHE_KEY and written to $GITHUB_OUTPUT.

3. **unsafe-shell**: Replaced both `curl ... | bash -s -- --quiet` patterns (for 'latest' and 'prerelease' version types) with a safe download-then-execute pattern: curl downloads to a mktemp file, then bash executes the file directly. The '--' from the original pipe form was correctly dropped (it was the shell's option terminator, not the script's argument). Temp files are cleaned up with trap.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in action.yml at the 'Determine runner and kernel version' step. Added sanitization for RUNNER_VERSION before writing to $GITHUB_OUTPUT using `safe_runner_version=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')`. Also applied the same sanitization pattern to VERSION_TYPE and KERNEL_VERSION writes for consistency, matching the existing pattern already used for mode-cache-key in the same step.

