module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_enabled_log_types = ["api", "audit"]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    # The attach_cluster_primary_security_group is a parameter in the EKS module that determines whether the cluster's primary security group should be attached to the worker nodes in addition to the node security group.
    # Here's what it does:
    # When set to true:
    # The primary security group of the EKS cluster (the one created for the control plane) is attached to all worker nodes.
    # This ensures that the worker nodes can communicate directly with the EKS control plane using the rules defined in the cluster's primary security group.
    # When set to false (default):
    # Only the node security group is attached to the worker nodes.
    # Communication between worker nodes and the control plane relies on the rules defined in the node security group.
    # Using attach_cluster_primary_security_group = true can be helpful in scenarios where:
    # You want to ensure direct communication between worker nodes and the control plane without managing additional security group rules.
    # You're experiencing connectivity issues between worker nodes and the control plane.
    # You prefer a simpler security group setup, even though it might be less granular.

    ## attach_cluster_primary_security_group = true
    create_security_group = true
    iam_role_additional_policies = {
      ecr_access = aws_iam_policy.ecr_access_policy.arn
    }
  }

  # for a private subnet for the cluster, this is important. 
  # create_security_group above will attach a cluster_sg and a node_sg 
  # mark the node_sg as owned  by the cluster so k8s doesnt barf on the internal-elb
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


