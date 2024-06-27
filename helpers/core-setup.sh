#!/usr/bin/env bash

# Set k8sServiceHost dynamically. You can pass this as an argument to the script.
# subnetPrefix=$1
# clusterName=$2

# set in .envrc file

######################## ----- Setup the Cilium environment
################################################################

helm repo add cilium https://helm.cilium.io/
helm repo update
latest_cilium_version=$(helm search repo cilium | grep cilium/cilium | awk '{print $2}')
# Use process substitution to provide the YAML content directly to Helm
helm upgrade --install --namespace kube-system cilium cilium/cilium --version $latest_cilium_version -f <(
    cat <<EOF
kubeProxyReplacement: true
k8sServiceHost: ${subnetPrefix}.10
k8sServicePort: 6443
k8sClientRateLimit:
  qps: 50
  burst: 100
gatewayAPI:
  enabled: true
ingressController:
  enabled: true
  loadbalancerMode: dedicated
  default: true
l2announcements:
  enabled: true
  leaseDuration: 3s
  leaseRenewDeadline: 2s
  leaseRetryPeriod: 500ms
externalIPs:
  enabled: true
EOF
)
sleep 30

######################## ----- Setup gateway-api
################################################################

# Fetch the latest release from the GitHub API - gateway-api
latest_gatewayapi_version=$(curl --silent "https://api.github.com/repos/kubernetes-sigs/gateway-api/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
# Define the URLs
urls=(
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml"
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/standard/gateway.networking.k8s.io_gateways.yaml"
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml"
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml"
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/experimental/gateway.networking.k8s.io_grpcroutes.yaml"
    "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${latest_gatewayapi_version}/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml"
)
# Loop over the URLs and replace the version
for url in "${urls[@]}"; do
    url=${url/VERSION/$latest_version}
    kubectl apply -f $url
done

sleep 10

######################## ----- Setup cilium balancerpool
################################################################

kubectl apply -f <(
    cat <<EOF
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "cilium-ip-pool"
spec:
  blocks:
  - start: "${subnetPrefix}.150"
    stop: "${subnetPrefix}.254"
EOF
)

sleep 10

######################## ----- Setup cilium l2AnnoucementPolicy
################################################################

kubectl apply -f <(
    cat <<EOF
apiVersion: "cilium.io/v2alpha1"
kind: CiliumL2AnnouncementPolicy
metadata:
  name: basic-policy
spec:
  interfaces:
  - ens3
  externalIPs: true
  loadBalancerIPs: true
EOF
)

sleep 10

######################## ----- Setup Cert Manager
################################################################

helm repo add jetstack https://charts.jetstack.io
helm repo update
latest_certmanager_version=$(helm search repo cert-manager | grep jetstack/cert-manager | awk '{print $2}' | head -n 1)
helm upgrade --install cert-manager jetstack/cert-manager --version $latest_certmanager_version \
    --namespace cert-manager \
    --set installCRDs=true \
    --create-namespace \
    --set "extraArgs={--feature-gates=ExperimentalGatewayAPISupport=true}"

sleep 30

######################## ----- Setup Longhorn
################################################################

helm repo add longhorn https://charts.longhorn.io
helm repo update
latest_longhorn_version=$(helm search repo longhorn | grep longhorn/longhorn | awk '{print $2}' | head -n 1)
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version $latest_longhorn_version

sleep 30

######################## ----- Setup Longhorn Certs for Portal
################################################################

kubectl apply -f <(
    cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: "lh-${clusterName}-srvrs-co-cloudflare-api-token-secret"
  namespace: longhorn-system
type: Opaque
stringData:
  api-token: ${cfToken}
EOF
)

kubectl apply -f <(
    cat <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-staging
  namespace: longhorn-system
spec:
  acme:
    # The ACME server URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: dustin@bashfulrobot.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-staging
    # Enable the CLoudflare DNS challenge provider
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: lh-${clusterName}-srvrs-co-cloudflare-api-token-secret
              key: api-token
EOF
)

kubectl apply -f <(
    cat <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: longhorn-system
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: dustin@bashfulrobot.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the CLoudflare DNS challenge provider
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: lh-${clusterName}-srvrs-co-cloudflare-api-token-secret
              key: api-token

EOF
)

######################## ----- Setup Longhorn ingress
################################################################

kubectl apply -f <(
    cat <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
# The name will end up: cilium-ingress-longhorn for the svc
  name: longhorn
  namespace: longhorn-system
  annotations:
    cert-manager.io/issuer: "letsencrypt-prod" # matches the name of the issuer in the NS
spec:
  ingressClassName: cilium
  rules:
    - host: lh-${clusterName}.srvrs.co
      http:
        paths:
        - backend:
            service:
              name: longhorn-frontend
              port:
                number: 80
          path: /
          pathType: Prefix
  tls:
    - hosts:
      - lh-${clusterName}.srvrs.co
      secretName: lh-${clusterName}-srvrs-co-tls
EOF
)
