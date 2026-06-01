variable "private_subnet_ids" {
  description = "List of private subnet IDs (at least two for RDS)"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group ID that allows database access from web tier"
  type        = string
}

variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  sensitive   = true
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  sensitive   = true
  # You should override this via terraform.tfvars or environment variable
  default     = "ChangeMeNow123!"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}
