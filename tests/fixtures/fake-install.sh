#!/bin/sh
# Fake CodSpeed installer - installs a mock codspeed binary
# Accepts --quiet and other flags, ignores them

# Find a suitable install location on PATH
INSTALL_DIR=""
for dir in /usr/local/bin /usr/bin "$HOME/.local/bin" "$HOME/bin"; do
  if [ -d "$dir" ] && [ -w "$dir" ]; then
    INSTALL_DIR="$dir"
    break
  fi
done

if [ -z "$INSTALL_DIR" ]; then
  # Try to create ~/.local/bin
  mkdir -p "$HOME/.local/bin"
  INSTALL_DIR="$HOME/.local/bin"
  export PATH="$INSTALL_DIR:$PATH"
fi

cat > "$INSTALL_DIR/codspeed" << 'CODSPEED_EOF'
#!/bin/sh
# Fake codspeed binary for testing
echo "CodSpeed mock runner: $*"
exit 0
CODSPEED_EOF

chmod +x "$INSTALL_DIR/codspeed"
echo "CodSpeed mock runner installed to $INSTALL_DIR/codspeed"
