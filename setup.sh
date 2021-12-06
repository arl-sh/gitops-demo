#!/bin/bash

CLUSTER_NAME=gitops
GITHUB_TOKEN="ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
GITHUB_USERNAME="au2001"
GITHUB_REPOSITORY="gitops-demo"

cd "$(dirname "$0")"

kind delete cluster --name="$CLUSTER_NAME"

kind create cluster --config kind-cluster.conf --name="$CLUSTER_NAME"

GITHUB_TOKEN="$GITHUB_TOKEN" flux bootstrap github --owner="$GITHUB_USERNAME" --repository="$GITHUB_REPOSITORY" --branch=main --path="./clusters/$CLUSTER_NAME" --personal --token-auth
