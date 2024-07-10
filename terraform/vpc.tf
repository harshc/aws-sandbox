module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # these tags are super important. And need to be exactly like this
  # The controller looks for this specific tag key to identify the subnets where it should create the ALB.
  # "kubernetes.io/cluster/${var.cluster_name}" = "shared" indicates that the subnets are shared by the EKS cluster.
  # "kubernetes.io/role/internal-elb" = "1" specifies that the subnets can be used for provisioning internal load balancers.
  public_subnet_tags = merge(local.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  })

  private_subnet_tags = merge(local.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  })
}
