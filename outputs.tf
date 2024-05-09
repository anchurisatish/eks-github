output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "eks" {
  description = "EKS Output"
  value       = module.eks
}

output "vpc_id" {
  description = "EKS Output"
  value       = module.vpc.vpc_id
}

output "prefix" {
  description = "EKS Output"
  value       = var.prefix
}
