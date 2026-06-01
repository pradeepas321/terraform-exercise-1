#step-4 adding ec2 instances
variable "private_subnet_id" {
  description = "The ID of the private subnet where the EC2 instance will be launched"
  type        = string
}

variable "web_security_group_id" {
  description = "The ID of the security group allowing SSH/HTTP/HTTPS to the instance"
  type        = string
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an EC2 Key Pair to enable SSH access. Set to an empty string to disable SSH key login."
  type        = string
  default     = "bootcamp-key"
}
