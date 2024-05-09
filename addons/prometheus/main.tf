resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  skip_crds  = false
  values = [
    jsonencode(local.base_values),
    jsonencode(local.kube_state_metrics_values),
    jsonencode(local.prometheus_node_exporter_values),
    jsonencode(local.additional_service_monitors_values)
  ]
  create_namespace = true
}
