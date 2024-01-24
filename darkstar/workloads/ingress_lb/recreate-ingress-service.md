# Fix the pending address

/var/lib/rancher/rke2/bin/kubectl delete helmchart rke2-ingress-nginx -n kube-system
/var/lib/rancher/rke2/bin/kubectl get helmchart -n kube-system
/var/lib/rancher/rke2/bin/kubectl apply -f /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx.yam
