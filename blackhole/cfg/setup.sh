#!/usr/bin/env bash

cd /home/dustin/dev/infra-home/clusters/blackhole/cfg

# Setup the Cilium environment
cd cilium
helm repo add cilium https://helm.cilium.io/
helm repo update
latest_version=$(helm search repo cilium | grep cilium/cilium | awk '{print $2}')
helm upgrade --install --namespace kube-system cilium cilium/cilium --version $latest_version -f cilium-values.yaml
sleep 2
bash ../apply-latest-cilium-api-gw-crd.sh
kubectl apply -f cilium-balancerpool.yaml
kubectl apply -f l2AnnoucementPolicy.yaml

# Setup Cert Manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
latest_version=$(helm search repo cert-manager | grep jetstack/cert-manager | awk '{print $2}' | head -n 1)
helm upgrade --install cert-manager jetstack/cert-manager --version $latest_version \
    --namespace cert-manager \
    --set installCRDs=true \
    --create-namespace \
    --set "extraArgs={--feature-gates=ExperimentalGatewayAPISupport=true}"

# Install longhorn
cd ../longhorn
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.2
cd certs
kubectl apply -f cm-le-lh-blackhole-secret.yaml
kubectl apply -f cm-le-staging-issuer.yaml
kubectl apply -f cm-le-prod-issuer.yaml
cd ..
kubectl apply -f cilium-ingress-lh.yaml