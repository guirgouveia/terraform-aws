# Sample test file for the VPC module

run "test_vpc" {
  assert {
    condition     = length(data.aws_vpc.existing.id) > 0
    error_message = "VPC does not exist."
  }

  assert {
    condition     = length(data.aws_subnet_ids.public.ids) == length(module.vpc.public_subnet_cidr_blocks)
    error_message = "Public subnets do not exist."
  }

  assert {
    condition     = length(data.aws_subnet_ids.private.ids) == length(module.vpc.private_subnet_cidr_blocks)
    error_message = "Private subnets do not exist."
  }

  assert {
    condition     = length(data.aws_internet_gateway.main.id) > 0
    error_message = "Internet gateway does not exist."
  }

  assert {
    condition     = length(data.aws_route_table.public.ids) == length(module.vpc.public_subnet_cidr_blocks)
    error_message = "Public route tables do not exist."
  }

  assert {
    condition     = length(data.aws_route_table.private.ids) == length(module.vpc.private_subnet_cidr_blocks)
    error_message = "Private route tables do not exist."
  }

  assert {
    condition     = module.vpc.nat_gateway_count > 0 && length(data.aws_nat_gateway.main) == module.vpc.nat_gateway_count
    error_message = "NAT gateways do not exist."
  }

  assert {
    condition     = module.vpc.nat_gateway_count > 0 && length(data.aws_eip.main) == module.vpc.nat_gateway_count
    error_message = "EIPs do not exist."
  }
}
