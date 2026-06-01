#step-2
#this is after step-1 creating vpcs and public and private subnets

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apple_dev_igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "apple_dev_nat_eip"
  }
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "apple_dev_nat_gw"
  }

  # Ensure IGW exists before NAT (good practice)
  depends_on = [aws_internet_gateway.main]
}
