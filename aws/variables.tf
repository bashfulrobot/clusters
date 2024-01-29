variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "VPC private subnets list"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  description = "VPC public subnets list"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

# please check following link for the list of all available eks_managed_node_groups options - https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/eks-managed-node-group/variables.tf#L284
variable "eks_managed_node_groups" {
  description = "EKS managed node group settings"
  default = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3.xlarge"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
    }
  }
}

variable "git_ssh_private_key_path" {
  description = "Path to SSH private key used for access to the git repo."
}

variable "git_repo_url" {
  description = "git repo url"
}

variable "sysdig_secure_access_key" {
  description = "Sysdig Secure access key"
}

variable "sysdig_secure_api_token" {
  description = "Sysdig Secure API token"
}

variable "sysdig_secure_url" {
  description = "Sysdig Secure URL"
}

variable "deploy_sysdig_secure_for_cloud" {
  type        = bool
  description = "Flag to deploy Sysdig Secure for Cloud module"
  default     = false
}
