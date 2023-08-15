#!/bin/bash

cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=190s

helm upgrade --install grafana --create-namespace -n monitoring grafana/grafana --set ingress.enabled=true --set ingress.hosts={grafana.10.11.0.35.nip.io} --set ingress.annotations={'kubernetes.io/ingress.class: nginx'}
helm upgrade --install loki grafana/loki -n monitoring --set minio.enabled=true
helm upgrade --install --wait podinfo --set ingress.enabled=true --set ingress.annotations.'kubernetes\.io\/ingress\.class'="nginx" --set 'ingress.hosts[0].host=podinfo.10.11.0.35.nip.io' --set 'ingress.hosts[0].paths[0].path=\/' --set 'ingress.hosts[0].paths[0].pathType=ImplementationSpecific' podinfo/podinfo

# http://victoria-metrics-victoria-metrics-cluster-vmselect.monitoring.svc.cluster.local:8481/select/0/prometheus/
