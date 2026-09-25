#!/bin/sh
# Fake CodSpeed installer - installs a mock codspeed binary that records its args
# Accepts --quiet and other flags, ignores them

# Install to /usr/local/bin/codspeed (standard location)
cat > /usr/local/bin/codspeed << 'CODSPEED_EOF'
#!/bin/sh
# Fake codspeed binary for testing - records args to a file
echo "CodSpeed runner (mock) - args: $*"
echo "$*" > /tmp/codspeed-args.txt
# Always succeed - simulates allow-empty behavior
exit 0
CODSPEED_EOF
chmod +x /usr/local/bin/codspeed
echo "CodSpeed runner (recording mock) installed"
