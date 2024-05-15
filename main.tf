provider "aws" {
  region = local.region
}

locals {
  region       = var.region
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
  prefix       = var.prefix
  vpc_cidr     = var.vpc_cidr
  eks_version  = var.eks_version
  cluster_name = "${local.prefix}-cluster"
  vpc_cni_addon_version = (
    var.vpc_cni_addon_version != "" ?
    var.vpc_cni_addon_version : data.aws_eks_addon_version.vpc_cni_latest.version
  )

  coredns_addon_version = (
    var.coredns_addon_version != "" ?
    var.coredns_addon_version : data.aws_eks_addon_version.coredns_latest.version
  )

  kube_proxy_addon_version = (
    var.kube_proxy_addon_version != "" ?
    var.kube_proxy_addon_version : data.aws_eks_addon_version.kube_proxy_latest.version
  )

  aws_ebs_csi_driver_addon_version = (
    var.aws_ebs_csi_driver_addon_version != "" ?
    var.aws_ebs_csi_driver_addon_version : data.aws_eks_addon_version.aws_ebs_csi_driver_latest.version
  )
}

data "aws_eks_addon_version" "vpc_cni_latest" {
  addon_name         = "vpc-cni"
  kubernetes_version = var.eks_version
  most_recent        = true
}

data "aws_eks_addon_version" "coredns_latest" {
  addon_name         = "coredns"
  kubernetes_version = var.eks_version
  most_recent        = true
}

data "aws_eks_addon_version" "kube_proxy_latest" {
  addon_name         = "kube-proxy"
  kubernetes_version = var.eks_version
  most_recent        = true
}

data "aws_eks_addon_version" "aws_ebs_csi_driver_latest" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.eks_version
  most_recent        = true
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${local.prefix}-vpc"
  cidr = local.vpc_cidr
  azs  = local.azs

  enable_nat_gateway = true
  create_igw         = true
  single_nat_gateway = true

  enable_dns_hostnames = true

  tags = { Name = "${local.prefix}-vpc" }

  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.prefix}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.prefix}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.prefix}-default" }
}

module "aws_ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.34.0"

  role_name             = "${var.prefix}-eks-aws-ebs-csi-driver"
  attach_ebs_csi_policy = true
  #ebs_csi_kms_cmk_ids   = [aws_kms_key.ebs.arn]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.34.0"

  role_name             = "${var.prefix}-eks-vpc-cni"
  attach_vpc_cni_policy = true
  role_policy_arns = {
    eks_cni_policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }
  #ebs_csi_kms_cmk_ids   = [aws_kms_key.ebs.arn]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.2.0"

  cluster_name    = local.cluster_name
  cluster_version = local.eks_version

  cluster_endpoint_public_access       = var.enable_public_cluster_endpoint
  cluster_endpoint_private_access      = var.enable_private_cluster_endpoint
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidr_blocks

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_addons = {
    coredns = {
      addon_version = local.coredns_addon_version
    }
    kube-proxy = {
      addon_version = local.kube_proxy_addon_version
    }
    vpc-cni = {
      addon_version            = local.vpc_cni_addon_version
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
    aws-ebs-csi-driver = {
      addon_version            = local.aws_ebs_csi_driver_addon_version
      service_account_role_arn = module.aws_ebs_csi_driver_irsa.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    nodegroup-az1 = {
      instance_types = ["t1.2xlarge"]

      min_size     = 3
      max_size     = 5
      desired_size = 3

      iam_role_attach_cni_policy = true

      iam_role_additional_policies = {
        # Required by Karpenter
        additional = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  access_entries = {
    # One access entry with a policy associated
    acces_1 = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${var.account_no}:role/Admin"

      policy_associations = {
        access_1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

