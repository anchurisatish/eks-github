# Terraform Prometheus

This repo provides the [Terraform][] module to provision [Prometheus][] on top of a Kubernetes cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.8 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.1.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager_storage_class"></a> [alertmanager\_storage\_class](#input\_alertmanager\_storage\_class) | Storage class name for Alertmanager PVC. The default requires the storage-classes addon. | `string` | `"gp3-encrypted"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the kube-prometheus-stack Helm chart. | `string` | `"45.7.1"` | no |
| <a name="input_prometheus_metrics_retention"></a> [prometheus\_metrics\_retention](#input\_prometheus\_metrics\_retention) | Retention period for Prometheus metrics. | `string` | `"10d"` | no |
| <a name="input_prometheus_storage"></a> [prometheus\_storage](#input\_prometheus\_storage) | Volume size for persistent storage of Prometheus metrics, increase to support longer retention periods. | `string` | `"50Gi"` | no |
| <a name="input_prometheus_storage_class"></a> [prometheus\_storage\_class](#input\_prometheus\_storage\_class) | Storage class name for Prometheus PVC. The default requires the storage-classes addon. | `string` | `"io1-encrypted"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

[Terraform]: https://www.terraform.io/intro
[Prometheus]: https://prometheus.io
[Prometheus documentation]: https://prometheus.io/docs/prometheus/latest/configuration/configuration/
