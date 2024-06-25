#!/bin/bash

# Fetch the latest release from the GitHub API
latest_version=$(curl --silent "https://api.github.com/repos/kubernetes-sigs/gateway-api/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Define the URLs
urls=(
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml"
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/standard/gateway.networking.k8s.io_gateways.yaml"
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml"
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml"
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/experimental/gateway.networking.k8s.io_grpcroutes.yaml"
"https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/VERSION/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml"
)

# Loop over the URLs and replace the version
for url in "${urls[@]}"; do
    url=${url/VERSION/$latest_version}
    kubectl apply -f $url
done