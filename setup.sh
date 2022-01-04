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

GITHUB_TOKEN="$GITHUB_TOKEN" flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --context="kind-$CLUSTER_NAME" \
  --owner="$GITHUB_USERNAME" \
  --repository="$GITHUB_REPOSITORY" \
  --branch=main \
  --path="$CLUSTER_PATH" \
  --personal \
  --token-auth

kubectl delete secret sops-gpg --namespace=flux-system

GPG_KEY_FINGERPRINT=`gpg --show-keys --with-fingerprint --with-colons secrets/.sops.pub.asc | awk -F: '$1 == "fpr" {print $10;}' | head -n 1`
gpg --export-secret-keys --armor "$GPG_KEY_FINGERPRINT" | kubectl create secret generic sops-gpg --namespace=flux-system --from-file=sops.asc=/dev/stdin
