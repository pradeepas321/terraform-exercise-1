variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "apple"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

# VPC CIDR – variable name matches the Name tag
variable "apple_dev_net" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.12.0.0/16"
}

# Public subnet CIDR – variable name matches the Name tag
variable "apple_dev_pub_net" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "172.12.1.0/24"
}

# Private subnet CIDR – variable name matches the Name tag
variable "apple_dev_pvt_net" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "172.12.2.0/24"
}

##step-3 creating rds databases

# RDS related variables
variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for PostgreSQL (sensitive)"
  type        = string
  sensitive   = true
  default     = "ChangeMeNow123!"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

#step-4 adding ec2 instances 

variable "key_name" {
  description = "Name of an existing EC2 Key Pair to enable SSH access"
  type        = string
  default     = "bootcamp-key"
}
