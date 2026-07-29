#!/bin/sh
# Fake CodSpeed installer for testing
# Installs a mock codspeed binary into /tmp/mock-bin (which is on PATH during tests)
# Accepts --quiet and other flags, ignores them

mkdir -p /tmp/mock-bin

cat > /tmp/mock-bin/codspeed << 'EOF'
#!/bin/sh
echo "CodSpeed mock runner - args: $*"
exit 0
EOF
chmod +x /tmp/mock-bin/codspeed
echo "Mock CodSpeed runner installed to /tmp/mock-bin/codspeed"
