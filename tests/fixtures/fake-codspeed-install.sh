#!/bin/sh
# Fake CodSpeed installer - installs a mock codspeed binary
set -e

# Parse arguments (ignore --quiet and other flags)
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

cat > "$INSTALL_DIR/codspeed" << 'EOF'
#!/bin/sh
# Fake codspeed binary for testing
echo "codspeed (fake) $@"
exit 0
EOF
chmod +x "$INSTALL_DIR/codspeed"

# Also install to /usr/local/bin if possible
if [ -w /usr/local/bin ]; then
  cp "$INSTALL_DIR/codspeed" /usr/local/bin/codspeed
fi

echo "Fake CodSpeed runner installed successfully"
