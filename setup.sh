#!/bin/bash

CLUSTER_NAME="gitops"
CLUSTER_PATH="./clusters/staging"
GITHUB_TOKEN="ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
GITHUB_USERNAME="au2001"
GITHUB_REPOSITORY="gitops-demo"

cd `dirname "$0"`

if [ "$1" == "reset" ]; then
    kind delete cluster --name="$CLUSTER_NAME"

    kind create cluster --config kind-cluster.conf --name="$CLUSTER_NAME"
fi

flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --context="kind-$CLUSTER_NAME" \
  --owner="$GITHUB_USERNAME" \
  --repository="$GITHUB_REPOSITORY" \
  --branch=main \
  --path="$CLUSTER_PATH" \
  --personal \
  --token-auth
