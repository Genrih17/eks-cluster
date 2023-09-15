output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "region" {
  description = "AWS region"
  value       = var.aws-region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for Amazon Web Service EKS "
  value       = module.eks.cluster_endpoint
}
