variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "us-east-1a-simpleapi"
}

variable "eks_cluster_version" {
  description = "EKS version to use"
  type        = string
  default     = "1.28"

}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.15.0/24"]
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default = {
    "Environment" = "sandbox"
    "Service"     = "simpleapi"
    "Owner"       = "Platform Engineering"
  }
}

