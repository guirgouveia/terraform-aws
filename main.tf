module "vpc" {
  source = "./modules/vpc" # Path to your local VPC module

  create_vpc                        = var.create_vpc
  vpc_name                          = var.vpc_name
  vpc_cidr_block                    = var.vpc_cidr_block
  nat_gateway_count                 = var.nat_gateway_count
  availability_zones_count          = var.availability_zones_count
  validate_vpc_cidr_block           = var.validate_vpc_cidr_block
  validate_nat_gateway_count        = var.validate_nat_gateway_count
  validate_availability_zones_count = var.validate_availability_zones_count
}


module "eks" {
  source = "./modules/eks" # Path to your local EKS module

  cluster_name = var.cluster_name

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  node_group_name             = var.node_group_name
  node_group_instance_type    = var.node_group_instance_type
  node_group_desired_capacity = var.node_group_desired_capacity
  scaling_config              = var.scaling_config

  tags = var.tags
}
