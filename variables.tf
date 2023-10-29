
# VPC module variables
variable "create_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name of the VPC to be created"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(regex("^10\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.vpc_cidr_block))
    error_message = "Invalid CIDR block format. Please provide a valid CIDR block in the format 10.x.x.x/xx"
  }
}

variable "nat_gateway_count" {
  description = "Number of NAT gateways to create"
  type        = number
  default     = 1
  validation {
    condition     = var.nat_gateway_count >= 1 && var.nat_gateway_count <= 3
    error_message = "Invalid NAT gateway count. Please provide a value between 1 and 3"
  }
}

variable "availability_zones_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
  validation {
    condition     = var.availability_zones_count >= 2 && var.availability_zones_count <= 3
    error_message = "Invalid availability zone count. Please provide a value between 2 and 3"
  }
}

variable "validate_vpc_cidr_block" {
  description = "Whether to validate the VPC CIDR block"
  type        = bool
  default     = true
}

variable "validate_nat_gateway_count" {
  description = "Whether to validate the NAT gateway count"
  type        = bool
  default     = true
}

variable "validate_availability_zones_count" {
  description = "Whether to validate the availability zone count"
  type        = bool
  default     = true
}

# EKS module variables
variable "cluster_name" {
  description = "Name of the EKS cluster to be created"
  type        = string
  default     = "my-eks-cluster"
}

variable "node_group_name" {
  description = "Name of the EKS node group to be created"
  type        = string
  default     = "my-node-group"
}

variable "node_group_instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
  default     = "t3.medium"
}

variable "node_group_desired_capacity" {
  description = "Desired capacity for the EKS node group"
  type        = number
  default     = 2
}

variable "scaling_config" {
  description = "Scaling configuration for the EKS node group"
  type        = map(any)
  default = {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(any)
  default = {
    Environment = "dev"
  }
}

variable "aws_access_key_id" {
  description = "AWS access key"
  type        = string
  default     = "AFSEW**********HUA3WD"
  validation {
    condition     = length(var.aws_access_key_id) >= 16
    error_message = "Invalid access key. Please provide an access key with at least 16 characters"
  }
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
  type        = string
  default     = "AFSEW**********HUA3WD"
  validation {
    condition     = length(var.aws_secret_access_key) >= 16
    error_message = "Invalid secret key. Please provide a secret key with at least 16 characters"
  }
}

