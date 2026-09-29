<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v4.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v4.18.1** was hardened automatically. 27 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings (sub-rule a), allowing attacker-controlled inputs to inject arbitrary shell commands.

Step 'Determine runner and kernel version':
- RUNNER_VERSION="${{ inputs.runner-version }}" — inputs.runner-version interpolated directly into shell
- MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-') — inputs.mode interpolated directly

Step 'Install CodSpeed runner':
- RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
- VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
- SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
- EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"

Step 'Run the benchmarks':
- if [ -z "${{ inputs.mode }}" ]
- if [ -n "${{ inputs.token }}" ] then --token "${{ inputs.token }}"
- --working-directory="${{ inputs.working-directory }}"
- --upload-url="${{ inputs.upload-url }}"
- --mode="${{ inputs.mode }}"
- --instruments="${{ inputs.instruments }}"
- --mongo-uri-env-name="${{ inputs.mongo-uri-env-name }}"
- if [ "${{ inputs.cache-instruments }}" = "true" ] && [ -n "${{ inputs.instruments-cache-dir }}" ]
- --setup-cache-dir="${{ inputs.instruments-cache-dir }}"
- if [ "${{ inputs.allow-empty }}" = "true" ]
- --go-runner-version="${{ inputs.go-runner-version }}"
- --config="${{ inputs.config }}"

All these should be moved to env: variables and referenced as quoted shell variables.

Locations:

- `action.yml:100`
- `action.yml:117`
- `action.yml:155`
- `action.yml:156`
- `action.yml:158`
- `action.yml:196`
- `action.yml:207`
- `action.yml:213`
- `action.yml:217`
- `action.yml:221`
- `action.yml:225`
- `action.yml:229`
- `action.yml:233`
- `action.yml:237`
- `action.yml:241`
- `action.yml:245`
- `action.yml:249`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization.

1. RUNNER_VERSION is set from ${{ inputs.runner-version }} (direct expression interpolation) and then written via: echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT. No printf '%s' ... | tr -d '\n\r' sanitization is applied before the write.

2. MODE_CACHE_KEY is derived from ${{ inputs.mode }} and written via: echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT. No sanitization is applied.

A newline character in either input value could inject additional key=value pairs into $GITHUB_OUTPUT, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:113`
- `action.yml:114`
- `action.yml:117`
- `action.yml:118`

### unsafe-shell (severity: high)

The 'Install CodSpeed runner' step pipes remote content directly to bash in two code paths without downloading to a file first:

1. For 'latest' version: curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet
   The remote install.sh is fetched and executed in a single pipeline with no hash verification.

2. For 'prerelease' version: curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet
   Same pattern — remote script piped directly to bash without integrity checking.

If the remote server is compromised or the connection is intercepted, arbitrary code will execute on the runner. Note: the release code path correctly downloads to a temp file and verifies a SHA-256 hash, but the 'latest' and 'prerelease' paths do not.

Locations:

- `action.yml:168`
- `action.yml:175`

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

1. script-injection / static-inline-injection: Moved all ${{ inputs.* }} and ${{ steps.*.outputs.* }} expressions from run: shell strings into env: blocks for all three affected steps ('Determine runner and kernel version', 'Install CodSpeed runner', 'Run the benchmarks'). Shell scripts now reference plain environment variables.

2. github-env-injection: Added printf '%s' "$VAR" | tr -d '\n\r' sanitization for all four values written to $GITHUB_OUTPUT (runner-version, version-type, kernel-version, mode-cache-key).

3. unsafe-shell: Fixed the 'latest' and 'prerelease' code paths in 'Install CodSpeed runner' to download the install script to a temp file first (curl ... -o "$INSTALLER_TMP") and then execute it (bash "$INSTALLER_TMP" --quiet), instead of piping directly to bash. Dropped the '--' from the original 'bash -s -- --quiet' since it was the shell's stdin option terminator and is not needed when running a file.

