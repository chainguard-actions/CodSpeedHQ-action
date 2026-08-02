#!/bin/sh
# Fake curl: intercept CodSpeed installer URLs and serve a fake install script.
# Supports both "curl URL | sh" (stdout) and "curl -o FILE URL" (write to file).
# Falls through to real curl for other URLs.

out=""
prev=""
is_codspeed_url=0

for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
  case "$arg" in
    *codspeed.io/install.sh*|*codspeed.io/v*/install.sh*)
      is_codspeed_url=1
      ;;
  esac
done

if [ "$is_codspeed_url" = "1" ]; then
  if [ -n "$out" ]; then
    # Write to file (hardened form: curl -o FILE URL)
    cat "$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh" > "$out"
    # Simulate HTTP 200 response code output for -w "%{http_code}"
    printf "200"
  else
    # Pipe form: curl URL | sh
    cat "$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh"
  fi
  exit 0
fi

# Fall through to real curl for other URLs
exec /usr/bin/curl "$@"
