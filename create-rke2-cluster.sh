#!/bin/bash

TOKEN="$1"
TEMPLATEFILE="${2:-rke2-cluster-calico.yaml}"

if [ -z "$TOKEN" ]; then
  echo "Usage: $0 <Rancher API Bearer Token> [<Cluster Template File>]"
  echo "If <Cluster Template File> is not provided, 'rke2-cluster-calico.yaml' will be used by default."
  exit 1
fi

rancher  login --skip-verify --token "$TOKEN" https://localhost

rancher kubectl apply -f "$TEMPLATEFILE"
rancher cluster list

echo "Cluster creation initiated. Go to cluster management, select the main cluster and follow the instructions to add nodes."