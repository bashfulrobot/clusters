variable "region" {
  description = "The AWS region to deploy into"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "dk-lab"
}

variable "eks_cluster_version" {
  description = "The version of the EKS cluster"
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"

  validation {
    condition     = length(var.vpc_cidr) > 0
    error_message = "The vpc_cidr variable must be provided."
  }
}

variable "vpc_private_subnets" {
  description = "values for the private subnets"
}

variable "vpc_public_subnets" {
  description = "values for the public subnets"
}

variable "eks_managed_node_group_defaults" {
  description = "The default values for the managed node group"

}
