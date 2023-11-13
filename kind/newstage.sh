helm upgrade --install nginx-ingress --create-namespace --namespace nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress \
--set controller.enableLatencyMetrics=true \
--set prometheus.service.create=true \
--set controller.replicaCount=3 \
--set controller.watchNamespace="default\,nginx-ingress\,elasticsearch"


helm upgrade --install elasticsearch --create-namespace --namespace elasticsearch --version 7.17.3 \
elastic/elasticsearch \
--set secret.password="password"

helm upgrade --install kibana --create-namespace --namespace elasticsearch --version 7.17.3 elastic/kibana \
--set ingress.enabled=true \
--set 'ingress.hosts[0].host=kibana.10.255.255.11.nip.io' \
--set 'ingress.hosts[0].paths[0].path=\/'
