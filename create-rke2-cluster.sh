#!/bin/bash

TOKEN="$1"

rancher  login --skip-verify --token "$TOKEN" https://localhost:8443

rancher kubectl apply -f rke2-cluster-template.yaml
rancher cluster list

echo "Cluster creation initiated. Go to cluster management, select the main cluster and follow the instructions to add nodes."