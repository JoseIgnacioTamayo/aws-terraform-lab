#!/bin/bash

mkdir -p /tmp/health
sudo chmod aug+rx /tmp/health

cat > /tmp/health/index.html <<EOF
Content-Type: text/html

<!DOCTYPE html>
<html lang="en">
<body>
<h1>Hello from $(hostname)</h1>
</body>
</html>
EOF

python3 -m http.server 8080 -d /tmp/health &
