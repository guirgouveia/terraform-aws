
# Import the existing VPC if it exists
data "aws_vpc" "existing" {
  count = var.create_vpc ? 0 : 1

  tags = {
    Name = var.vpc_name
  }
}
