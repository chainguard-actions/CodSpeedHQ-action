#!/bin/sh
# Fake curl for testing CodSpeed action
# Intercepts CodSpeed installer downloads and serves the fake installer
# Supports both "curl URL | sh" (stdout) and "curl -o FILE URL" (write to file) modes
# Also handles -w "%{http_code}" for HTTP code output

out=""
write_out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
    -w|--write-out) write_out="$arg" ;;
  esac
  prev="$arg"
done

case "$*" in
  *codspeed.io*)
    if [ -n "$out" ]; then
      # Write to file mode (used by release version with hash check)
      cat "$GITHUB_WORKSPACE/tests/fixtures/fake-codspeed-install.sh" > "$out"
      # Output HTTP code if requested (must go to stdout)
      if [ -n "$write_out" ]; then
        printf "200"
      fi
    else
      # Pipe mode (used by latest/prerelease)
      cat "$GITHUB_WORKSPACE/tests/fixtures/fake-codspeed-install.sh"
    fi
    exit 0
    ;;
  *)
    # Fall through to real curl for other URLs
    exec /usr/bin/curl "$@"
    ;;
esac
