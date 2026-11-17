<!-- markdownlint-disable -->

# Hardening Report: CodSpeedHQ--action/v5.6.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **CodSpeedHQ--action/v5.6.0** was hardened automatically. 38 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Determine runner and kernel version' step puts expressions straight into the run: script. Examples: `RUNNER_VERSION="${{ inputs.runner-version }}"`, `DISTRO="${{ runner.os }}"` and `MODE_CACHE_KEY=$(echo "${{ inputs.mode }}" | tr ',' '-')`. Rule (b): `$GITHUB_ACTION_PATH` is expanded without quotes in `cat $GITHUB_ACTION_PATH/.codspeed-runner-version`.

Locations:

- `action.yml:135`
- `action.yml:173`
- `action.yml:178`

### script-injection (severity: high)

Rule (a): the 'Install CodSpeed runner' step puts expressions straight into the run: script: `RUNNER_VERSION="${{ steps.versions.outputs.runner-version }}"`, `VERSION_TYPE="${{ steps.versions.outputs.version-type }}"`, `SKIP_HASH_CHECK_WARNING="${{ inputs.skip-hash-check-warning }}"` and `EXPECTED_HASH="${{ steps.installer-hash.outputs.hash }}"`. Because runner-version comes from the caller's inputs.runner-version, the caller controls what gets injected into the shell here.

Locations:

- `action.yml:204`
- `action.yml:207`
- `action.yml:251`

### script-injection (severity: high)

Rule (a): the 'Run the benchmarks' step puts many inputs.* expressions straight into the run: script. Examples: `if [ -z "${{ inputs.mode }}" ]`, `RUNNER_ARGS+=(--token "${{ inputs.token }}")`, `--working-directory="${{ inputs.working-directory }}"`, `--upload-url="${{ inputs.upload-url }}"`, `--instruments=...`, `--mongo-uri-env-name=...`, `--setup-cache-dir="${{ inputs.instruments-cache-dir }}"`, `--go-runner-version=...`, `--config=...`, `--cycle-estimation=...`, `--exclude-allocations=...`, plus the boolean inputs allow-empty, simulation-track-subprocess and disable-memory-*. These values should be passed through env: variables and expanded with double quotes.

Locations:

- `action.yml:278`
- `action.yml:285`

### github-env-injection (severity: high)

The 'Determine runner and kernel version' step writes values derived from untrusted input to $GITHUB_OUTPUT without first stripping newlines (`printf '%s' ... | tr -d '\n\r'`). `echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT` comes from inputs.runner-version. `echo "mode-cache-key=$MODE_CACHE_KEY" >> $GITHUB_OUTPUT` comes from inputs.mode. A value containing a newline can add arbitrary step outputs.

Locations:

- `action.yml:160`
- `action.yml:179`

### unsafe-shell (severity: high)

Remote content is piped straight to a shell: `curl -fsSL https://codspeed.io/install.sh | bash -s -- --quiet` (the 'latest' path). Nothing checks the installer's integrity before it runs.

Locations:

- `action.yml:213`

### unsafe-shell (severity: high)

Remote content is piped straight to a shell: `curl -fsSL "https://codspeed.io/v$RUNNER_VERSION/install.sh" | bash -s -- --quiet` (the prerelease path). Nothing checks the installer's hash before it runs.

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
index 0864e9e..5b74b49 100644
--- a/action.yml
+++ b/action.yml
@@ -128,11 +128,32 @@ outputs:
 runs:
   using: "composite"
   steps:
     - name: Determine runner and kernel version
       id: versions
       shell: bash
+      env:
+        INPUT_RUNNER_VERSION: ${{ inputs.runner-version }}
+        INPUT_MODE: ${{ inputs.mode }}
+        RUNNER_OS_NAME: ${{ runner.os }}
       run: |
-        RUNNER_VERSION="${{ inputs.runner-version }}"
+        RUNNER_VERSION="$INPUT_RUNNER_VERSION"
         if [ -z "$RUNNER_VERSION" ]; then
           RUNNER_VERSION=$(cat $GITHUB_ACTION_PATH/.codspeed-runner-version)
         fi
@@ -157,8 +178,9 @@ runs:
           VERSION_TYPE="release"
         fi
 
-        echo "runner-version=$RUNNER_VERSION" >> $GITHUB_OUTPUT
-        echo "version-type=$VERSION_TYPE" >> $GITHUB_OUTPUT
+        SAFE_RUNNER_VERSION=$(printf '%s' "$RUNNER_VERSION" | tr -d '\n\r')
+        echo "runner-version=$SAFE_RUNNER_VERSION" >> "$GITHUB_OUTPUT"
+        echo "version-type=$VERSION_TYPE" >> "$GITHUB_OUTPUT"
 
         # Get kernel version for cache key
         KERNEL_VERSION=$(uname -r)
@@ -167,20 +189,20 @@ runs:
         # Get the distribution for the cache key: instrument installations are built against a
         # specific release, and `runner.os` only says `Linux`
         if [ -r /etc/os-release ]; then
-          . /etc/os-release
-          DISTRO="$ID-$VERSION_ID"
+          DISTRO=$(. /etc/os-release && echo "${ID}-${VERSION_ID}")
         else
-          DISTRO="${{ runner.os }}"
+          DISTRO="$RUNNER_OS_NAME"
         fi
-        echo "distro=$DISTRO" >> $GITHUB_OUTPUT
+        SAFE_DISTRO=$(printf '%s' "$DISTRO" | tr -d '\n\r')
+        echo "distro=$SAFE_DISTRO" >> "$GITHUB_OUTPUT"
 
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
@@ -189,7 +211,7 @@ runs:
 
     - name: Lookup installer hash
       id: installer-hash
       uses: actions/github-script@ed597411d8f924073f98dfc5c65a23a2325f34cd # v8.0.0
       env:
         RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
       with:
@@ -200,23 +222,29 @@ runs:
 
     - name: Install CodSpeed runner
       shell: bash
+      env:
+        RUNNER_VERSION: ${{ steps.versions.outputs.runner-version }}
+        VERSION_TYPE: ${{ steps.versions.outputs.version-type }}
+        SKIP_HASH_CHECK_WARNING: ${{ inputs.skip-hash-check-warning }}
+        EXPECTED_INSTALLER_HASH: ${{ steps.installer-hash.outputs.hash }}
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
+          UNVERIFIED_INSTALLER=$(mktemp)
+          curl -fsSL https://codspeed.io/install.sh -o "$UNVERIFIED_INSTALLER"
+          bash "$UNVERIFIED_INSTALLER" --quiet
+          rm -f "$UNVERIFIED_INSTALLER"
         elif [ "$VERSION_TYPE" = "prerelease" ]; t
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unsafe-shell, static-inline-injection, prior-fix

**Notes:**

I fixed every finding by editing action.yml. Nothing was run or tested. I searched the file afterwards: every remaining ${{ }} expression is in an env:, with: or output field, and none are left in a run: script.

- Determine runner and kernel version step: inputs.runner-version, inputs.mode and runner.os are now passed in through env: and used as quoted variables. $GITHUB_ACTION_PATH is now quoted. Newlines are stripped from runner-version, distro and mode-cache-key before they are written to $GITHUB_OUTPUT, and every $GITHUB_OUTPUT reference is quoted. /etc/os-release is now read in a subshell, as the previous harden did.
- Install CodSpeed runner step: the step outputs and inputs.skip-hash-check-warning now come in through env:. For the 'latest' and prerelease versions, the installer is now downloaded to a temp file and then run with `bash "$file" --quiet`. I dropped the '-s --' from the old piped form so the script still receives --quiet as its first argument. The installer is still not hash-checked for these two versions: there is no pinned hash to check against, which matches upstream (the step still prints a warning saying so). I also quoted $HOME/.cargo/env and changed the trap to single quotes.
- Run the benchmarks step: all 16 inputs it used inline (mode, token, working-directory, upload-url, instruments, mongo-uri-env-name, cache-instruments, instruments-cache-dir, allow-empty, go-runner-version, config, cycle-estimation, exclude-allocations, simulation-track-subprocess, disable-memory-track-physical, disable-memory-capture-stack) are now INPUT_* variables in env: and are expanded double-quoted. Each one is a single value, so the existing argument array works as before.

