#step-1 
#required for creating vpc and subnets

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

#step-2.2
#create internet gateway, elastic IP and nat gatway 

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "nat_eip_id" {
  value = aws_eip.nat.id
}

output "nat_eip_public_ip" {
  value = aws_eip.nat.public_ip
}

##step-2.2 after adding internet gw, nat gateway adding route tables

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

##step 2.3, after adding igw, eip and nat gw and adding route tables, you add security groups
output "web_security_group_id" {
  value = aws_security_group.web.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

#step-2 for rds vpc configuration
output "private_subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.private_2.id]
}
