# Define the input variables for the EKS module
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "example-eks-cluster"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created."
  type        = string
  default     = "example-vpc-id"
}

variable "subnets" {
  description = "The IDs of the subnets where the EKS cluster will be created."
  type        = list(string)
  default     = ["example-subnet-id-1", "example-subnet-id-2"]
}

variable "tags" {
  description = "The tags to apply to the EKS cluster resources."
  type        = map(string)
  default = {
    Environment = "example"
    Owner       = "example"
  }
}

variable "node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "example-node-group"
}

variable "node_group_instance_type" {
  description = "The instance type for the EKS node group instances."
  type        = string
  default     = "t3.medium"
  validation {
    condition     = can(regex("t3.*", var.node_group_instance_type))
    error_message = "Instance type must start with 't3'."
  }
}

variable "node_group_desired_capacity" {
  description = "The desired capacity for the EKS node group."
  type        = number
  default     = 2
  validation {
    condition     = var.node_group_desired_capacity >= 2 && var.node_group_desired_capacity <= 10
    error_message = "Desired capacity must be between 2 and 10."
  }
}

variable "node_group_instance_size" {
  description = "The instance size to use for the EKS node group"
  type        = string
  default     = "t2.medium"
}

variable "scaling_config" {
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })

  default = {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

