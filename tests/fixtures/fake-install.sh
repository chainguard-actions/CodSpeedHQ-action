#!/bin/sh
# Fake CodSpeed installer - installs a mock codspeed binary
# Accepts --quiet and other flags, ignores them

# Install to /usr/local/bin (standard location)
cat > /usr/local/bin/codspeed << 'CODSPEED_EOF'
#!/bin/sh
# Fake codspeed binary for testing
echo "CodSpeed runner (mock) - args: $*"
# Always succeed - simulates allow-empty behavior
exit 0
CODSPEED_EOF
chmod +x /usr/local/bin/codspeed
echo "CodSpeed runner installed successfully (mock)"
