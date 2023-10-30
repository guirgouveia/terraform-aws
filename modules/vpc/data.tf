# Retrieves a list of available availability zones for the current region
data "aws_availability_zones" "available" {
  state = "available"
}