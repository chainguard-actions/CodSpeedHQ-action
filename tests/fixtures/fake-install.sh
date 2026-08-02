#!/bin/sh
# Fake CodSpeed installer - installs a fake codspeed binary
set -e

# Parse args (--quiet etc.)
# Just install a fake codspeed binary
cat > /usr/local/bin/codspeed << 'FAKE_CODSPEED'
#!/bin/sh
# Fake codspeed binary for testing
echo "CodSpeed runner (fake) called with args: $*"
exit 0
FAKE_CODSPEED
chmod +x /usr/local/bin/codspeed
echo "Fake CodSpeed runner installed successfully"
