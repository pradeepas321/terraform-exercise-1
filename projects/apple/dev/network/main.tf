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

#step-3 adding this new vpc due to RDS requirement. you cant workaround this problem so you have to create new private net for RDS. 

# Second private subnet in a different AZ (required for RDS)
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.12.3.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "apple_dev_pvt_net_2"
  }
}
