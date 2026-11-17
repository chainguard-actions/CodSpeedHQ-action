<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.3** was hardened automatically. 38 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Determine runner and kernel version' step puts expressions straight into the run: script. Offending lines: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. Because the values are substituted before the shell parses the script, an input containing " or $(...) can run arbitrary commands. Fix: pass them in through env: and use "$VAR" in the script. Also use $RUNNER_OS instead of runner.os.

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

Rule (a): the 'Install CodSpeed runner' step puts expressions straight into the run: script. Offending lines: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"` (this value comes from inputs.runner-version), `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`.

Locations:

- `action.yml:204`
- `action.yml:207`
- `action.yml:251`

### script-injection (severity: high)

Rule (a): the 'Run the benchmarks' step puts many ${{ inputs.* }} expressions straight into the run: script. Examples: `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `RUNNER_ARGS+=(--working-directory="${{ inputs.working-directory }}")`, and the same pattern for upload-url, mode, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config, cycle-estimation, exclude-allocations, simulation-track-subprocess, disable-memory-track-physical and disable-memory-capture-stack. Each should go into env: and be referenced as a double-quoted variable.

Locations:

- `action.yml:278`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values from untrusted inputs to $GITHUB_OUTPUT without first stripping newlines with printf '%s' | tr -d '\n\r'. Offending lines: `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` (from inputs.runner-version), `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` (from inputs.mode) and `echo "distro=$DISTRO" >> $GITHUB_OUTPUT`. A value containing a newline can add arbitrary extra outputs.

Locations:

- `action.yml:160`
- `action.yml:175`
- `action.yml:179`

### unsafe-shell (severity: high)

Remote content is piped straight into a shell with no verification: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (used when the version type is 'latest').

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

Remote content is piped straight into a shell with no verification: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (used for prerelease versions).

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index 0864e9e..918d4f2 100644
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
+        INPUT_RUNNER_VERSION: ${{ inputs.runner-version }}
+        INPUT_MODE: ${{ inputs.mode }}
+        GH_RUNNER_OS: ${{ runner.os }}
       run: |
-        RUNNER_VERSION="${{ inputs.runner-version }}"
+        RUNNER_VERSION="$INPUT_RUNNER_VERSION"
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
@@ -170,17 +192,18 @@ runs:
           . /etc/os-release
           DISTRO="$ID-$VERSION_ID"
         else
-          DISTRO="${{ runner.os }}"
+          DISTRO="$GH_RUNNER_OS"
         fi
-        echo "distro=$DISTRO" >> $GITHUB_OUTPUT
+        DISTRO=$(printf '%s' "$DISTRO" | tr -d '\n\r')
+        echo "distro=$DISTRO" >> "$GITHUB_OUTPUT"
 
         # Normalize mode for cache key (commas are not allowed in cache keys)
-        MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')
-        echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT
+        MODE_CACHE_KEY=$(printf '%s' "$INPUT_MODE" | tr ',' '-' | tr -d '\n\r')
+        echo "mode-cache-key=$MODE_CACHE_KEY" >> "$GITHUB_OUTPUT"
 
     - name: Cache CodSpeed instruments
       if: inputs.cache-instruments == 'true'
       uses: actions/cache@668228422ae6a00e4ad889ee87cd7109ec5666a7 # v5.0.4
       with:
         path: ${{ inputs.instruments-cache-dir }}
         key: codspeed-instruments-${{ steps.versions.outputs.mode-cache-key }}-${{ steps.versions.outputs.distro }}-${{ runner.arch }}-${{ steps.versions.outputs.kernel-version }}-${{ steps.versions.outputs.runner-version }}
@@ -189,7 +212,7 @@ runs:
 
     - name: Lookup installer hash
       id: installer-hash
       uses: actions/github-script@ed597411d8f924073f98dfc5c65a23a2325f34cd # v8.0.0
       env:
         RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
       with:
@@ -200,42 +223,48 @@ runs:
 
     - name: Install CodSpeed runner
       shell: bash
+      env:
+        RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
+        VERSION_TYPE: ${{ steps.versions.outputs.version-type }}
+        SKIP_HASH_CHECK_WARNING: ${{ inputs.skip-hash-check-warning }}
+        EXPECTED_HASH: ${{ steps.installer-hash.outputs.hash }}
       run: |
-        RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"
-        VERSION_TYPE="${{ steps.versions.outputs.version-type }}"
-
-        SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"
-
         if [ "$VERSION_TYPE" = "latest" ]; then
           if [ "$SKIP_HASH_CHECK_WARNING" != "true" ]; then
             echo "::warning::Hash verification is not available when using 'latest' version. Consider pinning a specific version for supply chain security."
           fi
-          curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet
+          INSTALLER_TMP=$(mktemp)
+          curl -fsSL https://co
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unsafe-shell, prior-fix

**Notes:**

action.yml: moved all ${{ }} expressions out of run: scripts into step env: blocks (GHA_INPUT_* vars, RUNNER_VERSION/VERSION_TYPE/SKIP_HASH_CHECK_WARNING/EXPECTED_HASH), replaced runner.os with $RUNNER_OS; sanitized runner-version, distro, and mode-cache-key with tr -d '\n\r' before writing to $GITHUB_OUTPUT and quoted $GITHUB_OUTPUT; replaced both curl | bash -s -- --quiet with download-to-mktemp then 'bash "$file" --quiet' (dropped -s and --); quoted $GITHUB_ACTION_PATH, $HOME/.cargo/env and the trap path. Behavior otherwise unchanged.

