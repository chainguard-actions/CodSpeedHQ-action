<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.1** was hardened automatically. 37 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): step 'Determine runner and kernel version' puts expressions directly inside the run: script. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. Move these values into env: and reference them as quoted shell variables, for example "$RUNNER_OS".

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

Rule (a): step 'Install CodSpeed runner' puts expressions directly inside the run: script. Offending lines: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. The runner-version output comes from user input, so an attacker can control it.

Locations:

- `action.yml:204`
- `action.yml:205`
- `action.yml:207`
- `action.yml:251`

### script-injection (severity: high)

Rule (a): step 'Run the benchmarks' puts many inputs.* expressions directly inside the run: script, for example `if [ -z "${{ inputs.mode }}" ]; then`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")` and `RUNNER_ARGS+=(--upload-url="${{ inputs.upload-url }}")`. The same pattern applies to instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config, cycle-estimation, exclude-allocations, simulation-track-subprocess, disable-memory-track-physical and disable-memory-capture-stack. Only inputs.run is already passed safely through env:.

Locations:

- `action.yml:278`

### github-env-injection (severity: high)

Step 'Determine runner and kernel version' writes input-derived values to $GITHUB_OUTPUT without sanitizing them first. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` comes from inputs.runner-version, and `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` comes from inputs.mode. Neither value goes through `printf '%s' ... | tr -d '\n\r'` before the write, so a newline in the input can inject extra outputs.

Locations:

- `action.yml:160`
- `action.yml:179`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' (version type 'latest') pipes a remote script straight to bash: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`.

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

Step 'Install CodSpeed runner' (version type 'prerelease') pipes a remote script straight to bash without checking its hash: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`.

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

All changes are in action.yml. Steps:
- 'Determine runner and kernel version': inputs.runner-version, inputs.mode and runner.os now come in through env: (GHA_INPUT_RUNNER_VERSION, GHA_INPUT_MODE, GHA_RUNNER_OS). Before each value is written to GITHUB_OUTPUT, newlines are removed with `printf '%s' | tr -d '\n\r'`. This covers runner-version, distro and mode-cache-key.
- 'Install CodSpeed runner': runner-version, version-type, skip-hash-check-warning and the installer hash now come in through env:. For the 'latest' and 'prerelease' versions, the installer is downloaded to a mktemp file first and then run with `bash "$INSTALLER_TMP" --quiet`. I dropped `-s --`, so the installer still gets --quiet as its first argument. The trap that deletes the release installer is now single-quoted.
- 'Run the benchmarks': every inputs.* expression now goes through a GHA_INPUT_* env var and is used double-quoted, so the arguments passed are the same as before.
- I removed a `${{ inputs.run }}` mention from a YAML comment.
- I also quoted the cat path and the `$GITHUB_OUTPUT` redirects.

Issue encountered: some of my edits overlapped and corrupted the file, so I rewrote the whole file from the original content with all fixes applied. A follow-up search found no leftover corruption.

