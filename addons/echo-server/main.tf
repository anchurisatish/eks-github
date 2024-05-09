locals {
  appName         = "echo-server"
  developer_group = "developers"
  labels = {
    app = local.appName
  }
  imageDigest = "jmalloc/echo-server:0.3.6"
}

resource "kubernetes_namespace" "echo_server" {
  metadata {
    name = local.appName
  }
}

# resource "kubernetes_role" "echo_server_developer_role" {
#   metadata {
#     name      = "developer"
#     namespace = local.appName
#   }
#   rule {
#     api_groups = ["*"]
#     resources  = ["configmaps", "pods", "podtemplates", "secrets", "serviceaccounts", "services", "deployments", "deployments/scale", "horizontalpodautoscalers", "networkpolicies", "statefulsets", "replicasets"]
#     verbs      = ["*"]
#   }

#   depends_on = [
#     kubernetes_namespace.echo_server
#   ]
# }

# resource "kubernetes_role_binding" "echo_server_developer_role" {
#   metadata {
#     name      = "developer"
#     namespace = local.appName
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = "developer"
#   }
#   subject {
#     kind      = "Group"
#     name      = local.developer_group
#     api_group = "rbac.authorization.k8s.io"
#     namespace = ""
#   }

#   depends_on = [
#     kubernetes_namespace.echo_server
#   ]
# }

resource "kubernetes_deployment_v1" "echo_server" {
  metadata {
    name      = local.appName
    namespace = kubernetes_namespace.echo_server.metadata[0].name
    labels    = local.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {

        container {
          name  = local.appName
          image = local.imageDigest

          image_pull_policy = "Always"

          port {
            name           = "http"
            container_port = 8080
          }

          # readiness_probe {
          #   http_get {
          #     path = "/"
          #     port = 8080
          #   }

          #   initial_delay_seconds = 5
          #   period_seconds        = 5
          # }

          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 8080
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }

          # security_context {
          #   capabilities {
          #     drop = ["NET_RAW", "ALL"]
          #   }
          #   read_only_root_filesystem  = true
          #   allow_privilege_escalation = false
          # }
        }
      }
    }
  }
}

resource "kubernetes_service" "echo_server" {
  metadata {
    name      = local.appName
    namespace = kubernetes_namespace.echo_server.metadata[0].name
  }

  spec {
    selector = {
      app = local.appName
    }
    #session_affinity = "ClientIP"

    port {
      port        = 80
      target_port = "http"
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "echo_ingress" {
  wait_for_load_balancer = true
  metadata {
    name      = local.appName
    namespace = kubernetes_namespace.echo_server.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/tags"        = "Environment=dev,Team=test"
    }
  }

  spec {
    ingress_class_name = "alb"

    # default_backend {
    #   service {
    #     name = local.appName
    #     port {
    #       number = 80
    #     }
    #   }
    # }


    rule {

      http {
        path {
          backend {
            service {
              name = local.appName
              port {
                number = 80
              }
            }
          }

          path      = "/echo"
          path_type = "Exact"
        }
      }
    }
  }
}

# resource "kubernetes_ingress_v1" "echo_ingress" {
#   wait_for_load_balancer = true
#   metadata {
#     name      = local.appName
#     namespace = kubernetes_namespace.echo_server.metadata[0].name
#     annotations = {
#       "nginx.ingress.kubernetes.io/rewrite-target" : "/"
#     }
#   }

#   spec {
#     ingress_class_name = "nginx"

#     default_backend {
#       service {
#         name = local.appName
#         port {
#           number = 80
#         }
#       }
#     }


#     rule {

#       http {
#         path {
#           backend {
#             service {
#               name = local.appName
#               port {
#                 number = 80
#               }
#             }
#           }

#           path      = "/"
#           path_type = "Exact"
#         }
#       }
#     }
#   }
# }
