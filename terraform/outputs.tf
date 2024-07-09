output "cluster_endpoint" {
  description = "EKS Control plane endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS Region"
  value       = var.region
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "lb_role_arn" {
  description = "ARN of IAM role for the ALB"
  value       = module.lb_role.iam_role_arn
}
