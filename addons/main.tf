locals {
  eks_outputs = data.terraform_remote_state.cluster.outputs
  eks         = local.eks_outputs.eks
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.eks.cluster_name
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.9.2"

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    wait = true
  }

  cluster_name      = local.eks.cluster_name
  cluster_endpoint  = local.eks.cluster_endpoint
  cluster_version   = local.eks.cluster_version
  oidc_provider_arn = local.eks.oidc_provider_arn
}

# module "metrics_server" {
#   source = "./metrics_server"
# }

# module "keda_scaler" {
#   source = "./keda_scaler"
# }

# module "prometheus" {
#   source     = "./prometheus"
#   depends_on = [module.nginx_ingress]
# }

# module "nginx_ingress" {
#   source = "./nginx-ingress"

#   prefix     = local.eks.cluster_name
#   depends_on = [module.keda_scaler]
# }

module "echo-server" {
  source = "./echo-server"
  depends_on = [
    module.eks_blueprints_addons
  ]
}
