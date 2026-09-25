<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.19.0** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions from untrusted inputs are directly interpolated inside run: shell command strings across three steps in action.yml.

Step 1 ('Determine runner and kernel version'): `${{ inputs.runner-version }}` and `${{ inputs.mode }}` are interpolated directly into the shell script. An attacker-controlled value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) would be executed by the shell.

Step 3 ('Install CodSpeed runner'): `${{ steps.versions.outputs.runner-version }}`, `${{ steps.versions.outputs.version-type }}`, `${{ inputs.skip-hash-check-warning }}`, and `${{ steps.installer-hash.outputs.hash }}` are all directly interpolated into the run: block.

Step 4 ('Run the benchmarks'): Numerous `${{ inputs.* }}` values are directly interpolated into the shell script, including `inputs.mode`, `inputs.token`, `inputs.working-directory`, `inputs.upload-url`, `inputs.instruments`, `inputs.mongo-uri-env-name`, `inputs.cache-instruments`, `inputs.instruments-cache-dir`, `inputs.allow-empty`, `inputs.go-runner-version`, and `inputs.config`. All of these should be passed via env: variables and then referenced as quoted shell variables (e.g., "$VAR") instead.

Locations:

- `action.yml:103`
- `action.yml:126`
- `action.yml:155`
- `action.yml:156`
- `action.yml:158`
- `action.yml:196`
- `action.yml:215`
- `action.yml:220`
- `action.yml:224`
- `action.yml:228`
- `action.yml:232`
- `action.yml:236`
- `action.yml:240`
- `action.yml:244`
- `action.yml:248`
- `action.yml:252`

### github-env-injection (severity: high)

Two values derived from untrusted inputs are written to $GITHUB_OUTPUT without the required newline-sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. `inputs.runner-version` is interpolated directly into the shell as `RUNNER_VERSION="${{ inputs.runner-version }}"`, processed, and then written to $GITHUB_OUTPUT via `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT`. A value containing a newline could inject additional key=value pairs into the output file.

2. `inputs.mode` is interpolated directly as `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')` — the `tr ',' '-'` filter only removes commas, not newlines — and then written to $GITHUB_OUTPUT via `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT`. A newline in the input would allow injecting arbitrary entries into $GITHUB_OUTPUT.

Fix: apply `safe=$(printf '%s' "$VAR" | tr -d '\n\r')` before every write to $GITHUB_OUTPUT.

Locations:

- `action.yml:119`
- `action.yml:126`
- `action.yml:127`

### unsafe-shell (severity: high)

Two occurrences in the 'Install CodSpeed runner' step pipe remote content directly to bash without first downloading to a file and verifying integrity:

1. `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` — used when VERSION_TYPE is 'latest'. The script is fetched and executed in a single pipeline with no hash verification.

2. `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` — used when VERSION_TYPE is 'prerelease'. Same pattern, no hash verification.

If the remote server or network is compromised, arbitrary code would be executed on the runner. The release path (which downloads to a temp file and verifies a SHA-256 hash) is the correct pattern and should be applied to all version types.

Locations:

- `action.yml:163`
- `action.yml:169`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: blocks to env: blocks in all three affected steps. Step 1 uses INPUT_RUNNER_VERSION and INPUT_MODE env vars. Step 3 (Install CodSpeed runner) uses RUNNER_VERSION, VERSION_TYPE, SKIP_HASH_CHECK_WARNING, and EXPECTED_HASH env vars. Step 4 (Run the benchmarks) uses INPUT_MODE, INPUT_TOKEN, INPUT_WORKING_DIRECTORY, INPUT_UPLOAD_URL, INPUT_INSTRUMENTS, INPUT_MONGO_URI_ENV_NAME, INPUT_CACHE_INSTRUMENTS, INPUT_INSTRUMENTS_CACHE_DIR, INPUT_ALLOW_EMPTY, INPUT_GO_RUNNER_VERSION, and INPUT_CONFIG env vars.

2. github-env-injection: Added printf '%s' ... | tr -d '\n\r' sanitization before writing runner-version and mode-cache-key to $GITHUB_OUTPUT.

3. unsafe-shell: Fixed both curl | bash patterns in the 'latest' and 'prerelease' version paths by downloading the install script to a temp file first, then executing it with bash. The '--' separator was correctly dropped as it was the shell's option terminator, not the script's argument.

