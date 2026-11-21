<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.8.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.8.0** was hardened automatically. 37 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Determine runner and kernel version' step puts expressions straight into the run script. Examples: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. A crafted input could run arbitrary shell commands.

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

Rule (a): the 'Install CodSpeed runner' step puts expressions straight into the run script. Examples: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:204`

### script-injection (severity: high)

Rule (a): the 'Run the benchmarks' step puts many input expressions straight into the run script. Examples: `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--instruments="${{ inputs.instruments }}"`, `--mongo-uri-env-name=...`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version=...`, `--config=...`, `--cycle-estimation=...`, `--exclude-allocations=...` and the boolean input comparisons.

Locations:

- `action.yml:278`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from inputs to $GITHUB_OUTPUT without first running `printf '%s' ... | tr -d '\n\r'`. The lines are `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (from inputs.runner-version) and `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (from inputs.mode). A value containing a newline could add extra outputs.

Locations:

- `action.yml:160`
- `action.yml:179`

### unsafe-shell (severity: high)

The 'latest' install path pipes remote content straight into a shell with no hash check: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`.

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

The prerelease install path pipes remote content straight into a shell with no hash check: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`.

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell

**Notes:**

action.yml: moved every ${{ }} expression out of the run: scripts into step env: blocks: runner-version, mode and runner.os in 'Determine runner and kernel version', the step outputs, skip-hash-check-warning and the installer hash in 'Install CodSpeed runner', and all inputs in 'Run the benchmarks'. The scripts now use quoted $VARs, and the RUNNER_ARGS array logic is unchanged. Newlines are now stripped from runner-version and mode-cache-key (printf '%s' | tr -d '\n\r') before they are written to GITHUB_OUTPUT. The latest and prerelease installers are now downloaded to a mktemp file with curl -fsSL and then run with 'bash "$file" --quiet'. The '-s --' from the pipe form was dropped. These two paths still have no hash check, as in upstream, which has no pinned hash for them.

