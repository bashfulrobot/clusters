helm repo add longhorn <https://charts.longhorn.io>
helm repo update

kubectl create namespace longhorn-system

# the IP should match the controller

helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --set ingress.enabled=true --set ingress.host=longhorn.10.0.0.15.sslip.io

### Verify the status of Longhorn

kubectl get pods --namespace longhorn-system --watch

## With a manifest

```
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.3/deploy/longhorn.yaml

kubectl get pods \
--namespace longhorn-system \
--watch

USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth

kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

kubectl -n longhorn-system apply -f longhorn-ingress.yaml
```
