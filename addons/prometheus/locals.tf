locals {
  base_values = {
    # These two options shorten absurdly-long generated resource names
    cleanPrometheusOperatorObjectNames = true
    fullnameOverride                   = "kps"

    # On EKS, etcd is not reachable from nodes so scraping is disabled
    kubeEtcd = {
      enabled = false
    }
  }

  kube_state_metrics_values = {
    kube-state-metrics = {
      fullnameOverride = "${local.base_values.fullnameOverride}-kube-state-metrics"
    }
  }

  prometheus_node_exporter_values = {
    prometheus-node-exporter = {
      fullnameOverride = "${local.base_values.fullnameOverride}-node-exporter"
    }
  }

  additional_service_monitors_values = {
    prometheus = {
      additionalServiceMonitors = [
        {
          name = "ingress-nginx-controller"
          additionalLabels = {
            "release" = "kube-prometheus-stack"
          }
          selector = {
            "matchLabels" = {
              "app.kubernetes.io/component" = "controller"
              "app.kubernetes.io/instance"  = "ingress-nginx"
              "app.kubernetes.io/name"      = "ingress-nginx"
            }
          }
          namespaceSelector = {
            "matchNames" = [
              "nginx-system",
            ]
          }
          endpoints = [
            {
              "interval" = "30s"
              "port"     = "metrics"
            }
          ]
        }
      ]
    }
  }
}
