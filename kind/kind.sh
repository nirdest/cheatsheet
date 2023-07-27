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

helm install victoria-metrics vm/victoria-metrics-cluster --create-namespace --namespace monitoring --set ingress.enabled=true --set ingress.hosts={vm.10.11.0.64.nip.io}  --set ingress.annotations: {kubernetes.io/ingress.class: nginx}
helm install grafana -n monitoring grafana/grafana --set ingress.enabled=true --set ingress.hosts={grafana.10.11.0.64.nip.io} --set ingress.annotations: {kubernetes.io/ingress.class: nginx}
helm install prometheus -n monitoring oci://registry-1.docker.io/bitnamicharts/kube-prometheus --set prometheus.remoteWrite={http://victoria-metrics-victoria-metrics-cluster-vminsert.monitoring.svc.cluster.local:8480/insert/0/prometheus/}
