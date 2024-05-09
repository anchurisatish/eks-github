# keda-nginx

This example shows how to autoscale nginx ingress controller based on prometheus metrics using KEDA

## Example details

This examples installs all the prerequisites for an EKS cluster:

- Creates a new sample VPC, 3 Private Subnets and 3 Public Subnets
- Creates Internet gateway for Public Subnets and NAT Gateway for Private Subnets
- Creates EKS Cluster Control plane with one managed node group
- The addons directory installs keda, metric_server, nginx controller, nginx-example app, prometheus

## How to Deploy

### Prerequisites

Ensure that you have installed the following tools in your Mac or Windows Laptop before start working with this module and run Terraform Plan and Apply

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [Kubectl](https://Kubernetes.io/docs/tasks/tools/)
3. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Initialization

#### Step 1: Clone the repo using the command below

```sh
git clone https://gitlab.aws.dev/ancsatis/keda-nginx.git
```

### Deployment

#### Step 3: Run Terraform INIT

Initialize a working directory with configuration files

```sh
terraform init
```

#### Step 4: Run Terraform PLAN

Verify the resources created by this execution

```sh
terraform plan
```

#### Step 5: Finally, Terraform APPLY

```sh
terraform apply
```

Enter `yes` to apply.

#### Step 6: Deploy Addons

```sh
cd addons
```

##### RUN Terraform INIT

```sh
terraform init
```

##### RUN Terraform Plan

Verify the resources created by this execution

```sh
terraform plan
```

##### Finally, Terraform APPLY

```sh
terraform apply
```

Enter `yes` to apply.

## Load test NGINX controller

Use the following command to create virtual users on ingress controllers
based on which KEDA autoscales the nginx deployment

Depending on the testing scanrio, change the virtual users and also
make sure to update the ingress URL

```sh
cd addons
k6 run --summary-trend-stats="min,avg,med,p(90),p(99),max,count" --summary-time-unit=ms k6.js
```

Refer [K6 Client][] for load testing.

Note: This testing used k6 client, please feel free to test the load using any preffered tool

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.54.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.7.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.19.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint_public_access_cidr_blocks"></a> [cluster\_endpoint\_public\_access\_cidr\_blocks](#input\_cluster\_endpoint\_public\_access\_cidr\_blocks) | List of CIDR blocks to allow access to EKS public API server endpoint. Can be used to configure CIDR ranges to access cluster. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_default_instance_type"></a> [default\_instance\_type](#input\_default\_instance\_type) | Default EC2 instance type for the two initial worker nodes. | `string` | `"t3.medium"` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | n/a | `string` | `"1.23"` | no |
| <a name="input_enable_private_cluster_endpoint"></a> [enable\_private\_cluster\_endpoint](#input\_enable\_private\_cluster\_endpoint) | Enables the EKS private API server endpoint. Set if you need to enable private access to eks. | `bool` | `false` | no |
| <a name="input_enable_public_cluster_endpoint"></a> [enable\_public\_cluster\_endpoint](#input\_enable\_public\_cluster\_endpoint) | Enables the EKS public API server endpoint. Set if you need to enable public access to eks. | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"eks-apg"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
| <a name="output_eks"></a> [eks](#output\_eks) | EKS Output |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | EKS cluster ID |
| <a name="output_prefix"></a> [prefix](#output\_prefix) | EKS Output |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | EKS Output |
<!-- END_TF_DOCS -->

[K6 Client]: https://k6.io/open-source/