module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_enabled_log_types = ["api", "audit"]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    #attach_cluster_primary_security_group = true
    create_security_group = false
    iam_role_additional_policies = {
      ecr_access = aws_iam_policy.ecr_access_policy.arn
    }
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Environment"                               = var.common_tags.Environment
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      tags           = local.tags
      subnet_ids     = module.vpc.private_subnets
    },
    two = {
      name           = "node-group-2"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      tags           = local.tags
      subnet_ids     = module.vpc.private_subnets
    }
  }

  cluster_security_group_additional_rules = {}
  cluster_security_group_tags = {
    "Name"        = "${var.cluster_name}-cluster-sg"
    "Environment" = var.common_tags.Environment
  }

  tags = local.tags
}


