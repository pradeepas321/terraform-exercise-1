# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.apple_dev_net
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "apple_dev_net"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.apple_dev_pub_net
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "apple_dev_pub_net"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.apple_dev_pvt_net
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "apple_dev_pvt_net"
  }
}
