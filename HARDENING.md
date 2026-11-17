<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.1** was hardened automatically. 38 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the composite step 'Determine runner and kernel version' puts expressions straight into the run: script. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. A caller-supplied input containing a quote, `$(...)` or a backtick runs as shell code. Fix: pass these values through env: variables and expand them double-quoted.

Locations:

- `action.yml:137`
- `action.yml:175`
- `action.yml:180`

### script-injection (severity: high)

Rule (a): the step 'Install CodSpeed runner' puts expressions straight into the run: script. Offending lines: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. The runner-version output comes from inputs.runner-version, so the caller controls it.

Locations:

- `action.yml:206`
- `action.yml:207`
- `action.yml:209`
- `action.yml:253`

### script-injection (severity: high)

Rule (a): the step 'Run the benchmarks' puts many input expressions straight into the run: script. Examples: `if [ -z "${{ inputs.mode }}" ]; then`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`, and the same pattern for upload-url, mode, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config, cycle-estimation, exclude-allocations, simulation-track-subprocess, disable-memory-track-physical and disable-memory-capture-stack. Only inputs.run goes safely through env (CODSPEED_INPUT_RUN). The other inputs should be routed through env: and expanded double-quoted.

Locations:

- `action.yml:280`
- `action.yml:287`
- `action.yml:288`

### github-env-injection (severity: high)

The step 'Determine runner and kernel version' writes values that come from inputs to $GITHUB_OUTPUT without the newline strip. `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (RUNNER_VERSION comes from inputs.runner-version) and `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (MODE_CACHE_KEY comes from inputs.mode) are not preceded by `printf '%s' ... | tr -d '\n\r'`. A value containing a newline can add extra output entries, for example forging version-type.

Locations:

- `action.yml:162`
- `action.yml:181`

### unsafe-shell (severity: high)

Remote installer piped straight into a shell: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (the 'latest' path in 'Install CodSpeed runner'). Nothing checks the downloaded script before it runs.

Locations:

- `action.yml:215`

### unsafe-shell (severity: high)

Remote installer piped straight into a shell: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (the prerelease path in 'Install CodSpeed runner'). Nothing checks the downloaded script before it runs.

Locations:

- `action.yml:221`

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index 0864e9e..2425d0c 100644
--- a/action.yml
+++ b/action.yml
@@ -128,13 +128,34 @@ outputs:
 runs:
   using: "composite"
   steps:
     - name: Determine runner and kernel version
       id: versions
       shell: bash
+      env:
+        GHA_INPUT_RUNNER_VERSION: ${{ inputs.runner-version }}
+        GHA_INPUT_MODE: ${{ inputs.mode }}
+        GHA_RUNNER_OS: ${{ runner.os }}
       run: |
-        RUNNER_VERSION="${{ inputs.runner-version }}"
+        RUNNER_VERSION="$GHA_INPUT_RUNNER_VERSION"
         if [ -z "$RUNNER_VERSION" ]; then
-          RUNNER_VERSION=$(cat $GITHUB_ACTION_PATH/.codspeed-runner-version)
+          RUNNER_VERSION=$(cat "$GITHUB_ACTION_PATH/.codspeed-runner-version")
         fi
         # Strip 'v' prefix if present to normalize version format
         RUNNER_VERSION="${RUNNER_VERSION#v}"
@@ -157,12 +178,13 @@ runs:
           VERSION_TYPE="release"
         fi
 
-        echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT
-        echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT
+        SAFE_RUNNER_VERSION=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
+        echo "runner-version=$SAFE_RUNNER_VERSION" >> "$GITHUB_OUTPUT"
+        echo "version-type=$VERSION_TYPE" >> "$GITHUB_OUTPUT"
 
         # Get kernel version for cache key
         KERNEL_VERSION=$(uname -r)
-        echo "kernel-version=$KERNEL_VERSION" >> $GITHUB_OUTPUT
+        echo "kernel-version=$KERNEL_VERSION" >> "$GITHUB_OUTPUT"
 
         # Get the distribution for the cache key: instrument installations are built against a
         # specific release, and `runner.os` only says `Linux`
@@ -170,17 +192,19 @@ runs:
           . /etc/os-release
           DISTRO="$ID-$VERSION_ID"
         else
-          DISTRO="${{ runner.os }}"
+          DISTRO="$GHA_RUNNER_OS"
         fi
-        echo "distro=$DISTRO" >> $GITHUB_OUTPUT
+        SAFE_DISTRO=$(printf '%s' "$DISTRO" | tr -d '\n\r')
+        echo "distro=$SAFE_DISTRO" >> "$GITHUB_OUTPUT"
 
         # Normalize mode for cache key (commas are not allowed in cache keys)
-        MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')
-        echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT
+        MODE_CACHE_KEY=$(printf '%s' "$GHA_INPUT_MODE" | tr ',' '-')
+        SAFE_MODE_CACHE_KEY=$(printf '%s' "$MODE_CACHE_KEY" | tr -d '\n\r')
+        echo "mode-cache-key=$SAFE_MODE_CACHE_KEY" >> "$GITHUB_OUTPUT"
 
     - name: Cache CodSpeed instruments
       if: inputs.cache-instruments == 'true'
       uses: actions/cache@668228422ae6a00e4ad889ee87cd7109ec5666a7 # v5.0.4
       with:
         path: ${{ inputs.instruments-cache-dir }}
         key: codspeed-instruments-${{ steps.versions.outputs.mode-cache-key }}-${{ steps.versions.outputs.distro }}-${{ runner.arch }}-${{ steps.versions.outputs.kernel-version }}-${{ steps.versions.outputs.runner-version }}
@@ -189,7 +213,7 @@ runs:
 
     - name: Lookup installer hash
       id: installer-hash
       uses: actions/github-script@ed597411d8f924073f98dfc5c65a23a2325f34cd # v8.0.0
       env:
         RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
       with:
@@ -200,23 +224,34 @@ runs:
 
     - name: Install CodSpeed runner
       shell: bash
+      env:
+        GHA_RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
+        GHA_VERSION_TYPE: ${{ steps.versions.outputs.version-type }}
+        GHA_SKIP_HASH_CHECK_WARNING: ${{ inputs.skip-hash-check-warning }}
+        GHA_EXPECTED_HASH: ${{ steps.installer-hash.outputs.hash }}
       run: |
-        RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
-        VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
+        RUNNER_VERSION="$GHA_RUNNER_VERSION"
+        VERSION_TYPE="$GHA_VERSION_TYPE"
 
-        SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
+        SKIP_HASH_CHECK_WARNING="$GHA_SKIP_HASH_CHECK_WARNING"
 
         if [ "$VERSION_TYPE" = "latest" ]; then
           if [ "$SKIP_HASH_CHECK_WARNING" != "true" ]; then
             echo "::warning::Hash verification is
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection, prior-fix

**Notes:**

action.yml: moved every ${{ }} expression out of the run: scripts in 'Determine runner and kernel version', 'Install CodSpeed runner' and 'Run the benchmarks' and into each step's env: block. The scripts now read them as double-quoted variables, and the RUNNER_ARGS array building is unchanged. Values written to $GITHUB_OUTPUT (runner-version, distro, mode-cache-key) now have newlines stripped first with printf | tr -d '\n\r', and $GITHUB_OUTPUT is quoted. The two 'curl | bash -s -- --quiet' installs (latest and prerelease) now save the script to a mktemp file and then run 'bash "$file" --quiet', with the '-s --' dropped. Also quoted the path in the .codspeed-runner-version cat and in the trap cleanup. This re-applies the previous harden's changes. No edits were made outside the scripts, and nothing was run to test the changes.

