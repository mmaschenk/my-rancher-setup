#!/bin/bash

start=$(date +%s)
rancherid=$(docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher:latest)

echo "Started Rancher container with ID: $rancherid"

PATTERN="Password"


echo "Waiting for Rancher to initialize..."

while true; do
  now=$(date +%s)
  elapsed=$((now - start))
  printf -v timer "%d:%02d" $((elapsed/60)) $((elapsed%60))
  # Fetch the latest logs
  LOGS=$(docker logs "$rancherid" 2>&1)

  # Search for the pattern
  MATCH=$(echo "$LOGS" | grep --line-buffered -F "$PATTERN")

  if [[ -n "$MATCH" ]]; then
    break
  else
    echo "$LOGS" | tail -n 10
    echo
    echo "Elapsed time: $timer"

    sleep 5
  fi
done


password=$(echo $MATCH| awk -F'Password: ' '{print $2}')

echo "Rancher initialization complete. Go to the interface and use ${password} to log in"
echo "Please note it may take a few minutes before the UI is fully responsive."

PATTERN="RDPClient: remotedialer session connected"
count=0
while true; do
  now=$(date +%s)
  elapsed=$((now - start))
  printf -v timer "%02d:%02d" $((elapsed/60)) $((elapsed%60))
  # Fetch the latest logs
  LOGS=$(docker logs "$rancherid" 2>&1)

  # Search for the pattern
  MATCH=$(echo "$LOGS" | grep --line-buffered -F "$PATTERN")

  if [[ -n "$MATCH" ]]; then
    echo "\rServer started!                    "
    break
  else
    printf "\rWaiting for server to start. %s (%d)   " $timer $count
    ((count++))
    sleep 5
  fi
done


echo
echo "Now go to https://localhost:8443 and login with the password above."
echo "Create an api key (top left screen) and run the script ./create-rke2-cluster.sh with the 'Bearer Token' as parameter to create a cluster."
