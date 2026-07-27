#!/bin/sh
# Fake CodSpeed installer - installs a mock codspeed binary
set -e

# Parse arguments (the real installer accepts --quiet and -b BINDIR)
BINDIR="/usr/local/bin"
while [ $# -gt 0 ]; do
  case "$1" in
    --quiet) shift ;;
    -b) BINDIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

mkdir -p "$BINDIR"

cat > "$BINDIR/codspeed" << 'CODSPEED_EOF'
#!/bin/sh
# Fake codspeed binary for testing
echo "CodSpeed runner (fake) - args: $*"
# Check for --allow-empty flag
ALLOW_EMPTY=false
for arg in "$@"; do
  case "$arg" in
    --allow-empty) ALLOW_EMPTY=true ;;
  esac
done
echo "CodSpeed run completed successfully (fake)"
exit 0
CODSPEED_EOF

chmod +x "$BINDIR/codspeed"
echo "Fake CodSpeed runner installed to $BINDIR/codspeed"
