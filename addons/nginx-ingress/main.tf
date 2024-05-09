locals {
  namespace = "nginx-system"

  aws_lb_annotation = "service.beta.kubernetes.io/aws-load-balancer"

  controller_service_annotations = {
    "${local.aws_lb_annotation}-name" : "${var.prefix}-ingress"
    "${local.aws_lb_annotation}-nlb-target-type" : "ip"
    "${local.aws_lb_annotation}-scheme" : "internet-facing"
    "${local.aws_lb_annotation}-ssl-ports" : "443"
    "${local.aws_lb_annotation}-type" : "external"
  }

  controller_service = {
    controller : {
      service : {
        annotations : merge(
          local.controller_service_annotations
        )
      }
    }
  }

  controller_metrics = {
    controller : {
      metrics : {
        enabled : true
      }
    }
  }
}


resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = local.namespace
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  create_namespace = true

  values = [
    jsonencode(local.controller_metrics)
  ]
}

resource "kubectl_manifest" "nginx_scaled_object" {
  yaml_body = <<-YAML
  apiVersion: keda.sh/v1alpha1
  kind: ScaledObject
  metadata:
    name: metric-server-scale
    namespace: nginx-system
  spec:
    scaleTargetRef:
      kind: Deployment
      name: ingress-nginx-controller
    minReplicaCount: 1
    maxReplicaCount: 10
    cooldownPeriod: 30
    pollingInterval: 10
    triggers:
    - type: prometheus
      metadata:
        serverAddress: http://kps-prometheus.prometheus.svc.cluster.local:9090
        metricName: nginx_ingress_controller_nginx_process_connections
        query: |
          avg(avg_over_time(nginx_ingress_controller_nginx_process_connections{state="active"}[1m]))
        threshold: "5"
  YAML

  depends_on = [
    helm_release.ingress_nginx,
  ]
}
