# Define the input variables

variable "create_vpc" {
  description = "Whether to create the VPC or import an existing one."
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "example"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrsubnet(var.vpc_cidr_block, 8, 0))
    error_message = "The provided CIDR block is not valid for VPC."
  }
}

variable "nat_gateway_count" {
  description = "The number of NAT gateways to create."
  type        = number
  default     = 1
  validation {
    condition     = var.nat_gateway_count > 0
    error_message = "The NAT gateway count must be a positive integer."
  }
}

variable "availability_zones_count" {
  description = "The number of availability zones to use."
  type        = number
  default     = 2
  validation {
    condition     = var.availability_zones_count > 0 && var.availability_zones_count <= 6
    error_message = "The availability zones count must be between 1 and 6."
  }
}

# Validators for the input variables

variable "validate_vpc_cidr_block" {
  description = "Whether to validate the VPC CIDR block."
  type        = bool
  default     = true
}

variable "validate_nat_gateway_count" {
  description = "Whether to validate the NAT gateway count."
  type        = bool
  default     = true
}

variable "validate_availability_zones_count" {
  description = "Whether to validate the availability zones count."
  type        = bool
  default     = true
}
