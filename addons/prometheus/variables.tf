variable "alertmanager_storage_class" {
  description = "Storage class name for Alertmanager PVC. The default requires the storage-classes addon."
  type        = string
  default     = "gp3-encrypted"
}

variable "chart_version" {
  description = "The version of the kube-prometheus-stack Helm chart."
  type        = string
  default     = "45.7.1"
}

variable "prometheus_metrics_retention" {
  description = "Retention period for Prometheus metrics."
  type        = string
  default     = "10d"
}

variable "prometheus_storage" {
  description = "Volume size for persistent storage of Prometheus metrics, increase to support longer retention periods."
  type        = string
  default     = "50Gi"
}

variable "prometheus_storage_class" {
  description = "Storage class name for Prometheus PVC. The default requires the storage-classes addon."
  type        = string
  default     = "io1-encrypted"
}

# variable "alertmanager_resources" {
#   description = "Resource requests and limits for prometheus alertmanager."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "100m",
#       memory = "50Mi"
#     },
#     limits = {
#       cpu    = "200m",
#       memory = "200Mi"
#     }
#   }
# }

# variable "prometheus_operator_resources" {
#   description = "Resource requests and limits for prometheus operator."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "100m",
#       memory = "100Mi"
#     },
#     limits = {
#       cpu    = "200m",
#       memory = "200Mi"
#     }
#   }
# }

# variable "prometheus_resources" {
#   description = "Resource requests and limits for the prometheus addon."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "500m",
#       memory = "4Gi"
#     },
#     limits = {
#       cpu    = "1500m",
#       memory = "4Gi"
#     }
#   }
# }

# variable "admission_webhooks_patch_resources" {
#   description = "Resource requests and limits for the prometheus admission webhooks Jobs."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "100m",
#       memory = "64Mi"
#     },
#     limits = {
#       cpu    = "200m",
#       memory = "256Mi"
#     }
#   }
# }

# variable "kube_state_metrics_resources" {
#   description = "Resource requests and limits for the kube state metrics."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "10m",
#       memory = "32Mi"
#     },
#     limits = {
#       cpu    = "100m",
#       memory = "64Mi"
#     }
#   }
# }

# variable "node_exporter_resources" {
#   description = "Resource requests and limits for the prometheus node exporter."
#   type = object({
#     requests = object({
#       cpu    = string
#       memory = string
#     })
#     limits = object({
#       cpu    = string
#       memory = string
#     })
#   })
#   default = {
#     requests = {
#       cpu    = "100m",
#       memory = "30Mi"
#     },
#     limits = {
#       cpu    = "200m",
#       memory = "50Mi"
#     }
#   }
# }
