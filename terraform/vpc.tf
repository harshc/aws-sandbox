module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # add tagging so we can do cost monitoring as well as identify resources later. 
  tags = merge(local.tags, {
    # this way we know all the clusters that are using this as a shared resource
    "k8s.cluster/${var.cluster_name}" = "shared"
  })

  public_subnet_tags = merge(local.tags, {
    "k8s.cluster/${var.cluster_name}" = "shared"
    "k8s.cluster/role/elb"            = "1"
  })

  private_subnet_tags = merge(local.tags, {
    "k8s.cluster/${var.cluster_name}" = "shared"
    "k8s.cluster/role/internal-elb"   = "1"
  })
}
