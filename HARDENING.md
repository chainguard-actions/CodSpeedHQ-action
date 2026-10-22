<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.0** was hardened automatically. 37 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Determine runner and kernel version' step puts ${{ }} expressions straight into its run script. Offending lines include RUNNER_VERSION="${{ inputs.runner-version }}", DISTRO="${{ runner.os }}" and MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-').

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

Rule (a): the 'Install CodSpeed runner' step puts ${{ }} expressions straight into its run script. Offending lines: RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}", VERSION_TYPE="${{ steps.versions.outputs.version-type }}", SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}" and EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}".

Locations:

- `action.yml:204`
- `action.yml:205`
- `action.yml:207`
- `action.yml:251`

### script-injection (severity: high)

Rule (a): the 'Run the benchmarks' step puts many ${{ inputs.* }} expressions straight into its run script, for example: if [ -z "${{ inputs.mode }}" ], RUNNER_ARGS+=(--token "${{ inputs.token }}"), --working-directory="${{ inputs.working-directory }}", --upload-url, --instruments, --mongo-uri-env-name, --setup-cache-dir="${{ inputs.instruments-cache-dir }}", --go-runner-version, --config, --cycle-estimation, --exclude-allocations, and the boolean checks on allow-empty, simulation-track-subprocess and the disable-memory-* inputs.

Locations:

- `action.yml:278`
- `action.yml:285`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values built from untrusted input to $GITHUB_OUTPUT without the printf '%s' | tr -d '\n\r' sanitization step. 'echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT' comes from inputs.runner-version. 'echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT' comes from inputs.mode. 'echo "distro=$DISTRO"' comes from runner.os or os-release.

Locations:

- `action.yml:160`
- `action.yml:175`
- `action.yml:179`

### unsafe-shell (severity: high)

Remote content is piped straight to a shell for the 'latest' version type: 'curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet'.

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

Remote content is piped straight to a shell for the prerelease version type: 'curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet'.

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.runner-version }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:135`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Determine runner and kernel version"; move to env: map

Locations:

- `action.yml:178`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.skip-hash-check-warning }}" appears directly in run: block of step "Install CodSpeed runner"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:285`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.token }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:286`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:288`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.working-directory }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-url }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:294`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mode }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:297`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:300`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mongo-uri-env-name }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:301`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-instruments }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.instruments-cache-dir }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:304`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.allow-empty }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:306`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:309`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.go-runner-version }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:310`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:312`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.config }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:313`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:315`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cycle-estimation }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:316`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:318`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.exclude-allocations }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:319`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.simulation-track-subprocess }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:321`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.disable-memory-track-physical }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:325`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.disable-memory-capture-stack }}" appears directly in run: block of step "Run the benchmarks"; move to env: map

Locations:

- `action.yml:328`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection

**Notes:**

Every ${{ }} expression in the three run: steps of action.yml (versions, install, run-benchmarks) now goes through the step's env: block and is read as a double-quoted shell variable, so the commands get the same arguments as before. The runner-version, distro and mode-cache-key values have newlines stripped before they are written to $GITHUB_OUTPUT. The two curl | bash -s -- --quiet installs (latest and prerelease) now download the script to a mktemp file and run it with 'bash "$file" --quiet'. I dropped the '-s --' as part of that change. These installs still have no hash check, same as upstream; the release path still checks the pinned hash. I didn't run the action or any tests after the changes.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Install CodSpeed runner step: the line EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}" now reads EXPECTED_HASH="$EXPECTED_INSTALLER_HASH", which the step's env: already sets from that output. The garbled curl/HTTP error block is rebuilt. If curl fails, the step reports the error, deletes the temp file and exits 1. If the HTTP code is not 200, it shows the response body and exits 1. Two more broken spots in the 'Determine runner and kernel version' step are also fixed. The /etc/os-release check was cut off partway, and there was a duplicated leftover mode-cache-key line. No upstream copy was available, so I wrote the distro line myself as DISTRO=$(. /etc/os-release && echo "${ID}-${VERSION_ID}"), falling back to the runner OS name. It may not match what upstream wrote, so please check it against upstream v5.6.0, because it changes the instruments cache key. Nothing has been run or linted.

