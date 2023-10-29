# Create the VPC if it doesn't exist
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Create the internet gateway
resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Create the private subnet(s)
resource "aws_subnet" "private" {
  count = var.availability_zones_count

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

# Create the public subnet(s)
resource "aws_subnet" "public" {
  count = var.availability_zones_count

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index + 8)
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

# Create the EIP(s) for the NAT gateway(s)
resource "aws_eip" "main" {
  count = var.availability_zones_count

  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-eip-${count.index + 1}"
  }
}

# Create the NAT gateway(s)
resource "aws_nat_gateway" "main" {
  count = var.availability_zones_count

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.main[count.index].id

  tags = {
    Name = "${var.vpc_name}-nat-${count.index + 1}"
  }
}

# Create the route table(s) for the private subnet(s)
resource "aws_route_table" "private" {
  count = var.availability_zones_count

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

# Create the route table(s) for the public subnet(s)
resource "aws_route_table" "public" {
  count = var.availability_zones_count

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

# Associate the private subnet(s) with the private route table(s)
resource "aws_route_table_association" "private" {
  count = var.availability_zones_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Associate the public subnet(s) with the public route table(s)
resource "aws_route_table_association" "public" {
  count = var.availability_zones_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# Create the routes for the NAT gateway(s)
resource "aws_route" "nat_gateway" {
  count = var.availability_zones_count

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index % var.nat_gateway_count].id
}

# Enable DNS support and hostnames for the VPC
resource "aws_vpc_dhcp_options" "main" {

  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  count = var.create_vpc ? 1 : 0

  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}