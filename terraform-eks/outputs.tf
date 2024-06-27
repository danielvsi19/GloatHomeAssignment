output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Worker nodes security group ID"
  value       = module.eks.node_security_group_id
}

output "kubectl_config" {
  description = "kubectl config file"
  value       = module.eks.kubeconfig
  sensitive   = true
}
