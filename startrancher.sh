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
    break
  else
    echo "$LOGS" | tail -n 10
    echo
    sleep 5
  fi
done


password=$(echo $MATCH| awk -F'Password: ' '{print $2}')

echo "Rancher initialization complete. Go to the interface and use ${password} to log in"

echo
echo "Now go to https://localhost:8443" and login with the password above."
echo "Create an api key and run the script ./create-rke2-cluster.sh with the api-token as parameter to create a cluster."
