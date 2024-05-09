locals {
  values = {
    securityContext = {
      allowPrivilegeEscalation = false
      runAsGroup               = 1001
      runAsUser                = 1001
    }
    podSecurityContext = {
      fsGroup = 1001
    }
  }
}

resource "helm_release" "keda_scaler" {
  namespace        = "keda"
  create_namespace = true
  name             = "keda"

  repository = "https://kedacore.github.io/charts"
  version    = "v${var.chart_version}"
  chart      = "keda"

  values = [yamlencode(local.values)]
}
