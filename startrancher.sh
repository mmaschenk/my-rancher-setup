#!/bin/bash

rancherid=$(docker run -d --restart=unless-stopped -p 8085:80 -p 8443:443 --privileged rancher/rancher:latest)

echo "Started Rancher container with ID: $rancherid"

PATTERN="Password"


echo "Waiting for Rancher to initialize..."

while true; do
  # Fetch the latest logs
  LOGS=$(docker logs "$rancherid" 2>&1)

  # Search for the pattern
  MATCH=$(echo "$LOGS" | grep --line-buffered -F "$PATTERN")

  if [[ -n "$MATCH" ]]; then
    echo ">>> Found pattern:"
    echo "$MATCH"
    exit 0
  else
    echo ">>> Pattern not found, showing last 10 lines:"
    echo "$LOGS" | tail -n 10
    echo ">>> Retrying in 5s..."
    echo
    sleep 5
  fi
done