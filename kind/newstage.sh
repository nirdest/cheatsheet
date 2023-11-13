helm upgrade --install nginx-ingress --create-namespace --namespace nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress \
--set controller.enableLatencyMetrics=true \
--set prometheus.service.create=true \
--set controller.replicaCount=3 \
--set controller.watchNamespace="default\,nginx-ingress\,elasticsearch"
