#!/bin/sh
# Fake curl: intercepts CodSpeed installer URLs and serves a mock installer.
# Supports both "curl URL | sh" (stdout) and hardened "curl -o FILE URL" (file).

out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
done

# Check if this is a CodSpeed installer URL
case "$*" in
  *codspeed.io*install.sh*)
    if [ -n "$out" ]; then
      cat "$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh" > "$out"
    else
      cat "$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh"
    fi
    exit 0
    ;;
esac

# Fall through to real curl for other URLs
exec /usr/bin/curl "$@"
