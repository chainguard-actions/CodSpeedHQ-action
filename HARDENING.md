<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.3** was hardened automatically. 37 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

(a) The 'Determine runner and kernel version' step puts ${{ }} expressions straight into the shell script: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. (b) It also expands $GITHUB_ACTION_PATH without quotes in `cat $GITHUB_ACTION_PATH/.codspeed-runner-version`.

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

(a) The 'Install CodSpeed runner' step puts ${{ }} expressions straight into the shell script: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. (b) It also expands $HOME without quotes in `source $HOME/.cargo/env`.

Locations:

- `action.yml:204`
- `action.yml:207`
- `action.yml:251`

### script-injection (severity: high)

(a) The 'Run the benchmarks' step puts many ${{ inputs.* }} expressions straight into the shell script, for example `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")` and `--upload-url`, `--mode`, `--instruments`, `--mongo-uri-env-name`, `--setup-cache-dir`, `--go-runner-version`, `--config`, `--cycle-estimation` and `--exclude-allocations` built the same way. The same applies to the comparisons on inputs.cache-instruments, inputs.allow-empty, inputs.simulation-track-subprocess and inputs.disable-memory-*. Each of these values should be passed in through env: and quoted.

Locations:

- `action.yml:278`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from inputs to $GITHUB_OUTPUT without the printf '%s' | tr -d '\n\r' sanitization step. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` comes from inputs.runner-version. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` comes from inputs.mode. A value containing a newline could inject extra outputs.

Locations:

- `action.yml:160`
- `action.yml:179`

### unsafe-shell (severity: high)

Remote content is piped straight into bash when 'latest' is used: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet`.

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

Remote content is piped straight into bash, with no hash check, for prerelease versions: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet`.

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

All changes are in action.yml. Version step: inputs.runner-version, inputs.mode and runner.os now come in through env:. $GITHUB_ACTION_PATH and $GITHUB_OUTPUT are quoted. runner-version, distro and mode-cache-key have newlines removed (printf '%s' | tr -d '\n\r') before they are written to GITHUB_OUTPUT. Install step: the steps.* outputs and inputs.skip-hash-check-warning now come in through env:. $HOME is quoted in 'source "$HOME/.cargo/env"', and the trap now quotes the temp file path. The 'latest' and prerelease installers are downloaded to a mktemp file with 'curl -fsSL -o' and then run with 'bash "$INSTALLER_TMP" --quiet' (the -s and -- from the pipe form are dropped). The release path with its hash check is unchanged. Run step: every inputs.* value now comes in through env: as an INPUT_* variable and is used double-quoted, so the argument list given to codspeed is the same as before. This includes instruments-cache-dir, which is still passed as the literal '~/.cache/codspeed-action' exactly as upstream did. I also reworded a YAML comment so it no longer contains expression syntax. One edit (adding env: to the version step) did not stick the first time even though it reported success, so I re-applied it and confirmed by searching the file. Nothing was run to test these changes.

