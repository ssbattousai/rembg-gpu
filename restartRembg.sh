#!/usr/bin/env bash
set -Eeuo pipefail

SERVICE="rembgd.service"

echo "Service : $SERVICE"
echo

# Restart the systemd service
echo "Restarting $SERVICE ..."
sudo systemctl restart "$SERVICE"

# Give the service a few seconds to come up
sleep 5

echo
echo "==============================="
echo "Running test request (curl localhost:7000)"
echo "==============================="
if [[ -f test.jpg ]]; then
  curl -s -F "file=@test.jpg" http://localhost:7000/api/remove --output out.png
  if [[ -s out.png ]]; then
    echo "✅ Test succeeded, output saved to out.png"
  else
    echo "⚠️ Test failed, no output produced"
  fi
else
  echo "⚠️ test.jpg not found in current directory, skipping test"
fi

echo
echo "==============================="
echo "Tailing last 200 lines of journal for $SERVICE"
echo "Press Ctrl+C to stop following logs"
echo "==============================="
sudo journalctl -u "$SERVICE" -f
