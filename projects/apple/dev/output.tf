
#step 1 create vpc and subnet

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.network.private_subnet_id
}

#step 3 create databases 
output "rds_endpoint" {
  value = module.database.rds_endpoint
}

#step-4  adding ec2 instances

output "app_private_ip" {
  value = module.compute.private_ip
}
