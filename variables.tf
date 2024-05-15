variable "prefix" {
  type    = string
  default = "eks-tf"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "eks_version" {
  type    = string
  default = "1.28"
}

variable "default_instance_type" {
  description = "Default EC2 instance type for the two initial worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "enable_public_cluster_endpoint" {
  description = "Enables the EKS public API server endpoint. Set if you need to enable public access to eks."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidr_blocks" {
  description = "List of CIDR blocks to allow access to EKS public API server endpoint. Can be used to configure CIDR ranges to access cluster."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_private_cluster_endpoint" {
  description = "Enables the EKS private API server endpoint. Set if you need to enable private access to eks."
  type        = bool
  default     = false
}

variable "vpc_cni_addon_version" {
  description = "VPC Container Network Interface (CNI) addon version. Set only if you cannot use the latest supported version of VPC CNI on your cluster version."
  type        = string
  default     = ""
}

# See https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html#updating-coredns-eks-add-on
variable "coredns_addon_version" {
  description = "CoreDNS addon version. Set only if you cannot use the latest supported version of CoreDNS on your cluster version."
  type        = string
  default     = ""
}

# See https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html#updating-kube-proxy-eks-add-on
variable "kube_proxy_addon_version" {
  description = "Kubernetes network proxy addon version. Set only if you cannot use the latest supported version of Kubernetes network proxy on your cluster version."
  type        = string
  default     = ""
}

# See https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html#updating-ebs-csi-eks-add-on
variable "aws_ebs_csi_driver_addon_version" {
  description = "Amazon Elastic Block Store (EBS) Container Storage Interface (CSI) Driver addon version. Set only if you cannot use the latest supported version of EBS CSI on your cluster version."
  type        = string
  default     = ""
}

variable "account_no" {
  type = string
}

#test
