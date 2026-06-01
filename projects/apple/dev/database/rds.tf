# Database subnet group (required, but free)
resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids  = var.private_subnet_ids   # requires at least two private subnets
  description = "Subnet group for RDS (minimal cost)"

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# RDS instance – cheapest possible configuration
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = "15.15"                 # current stable, replace with 16.x if needed
  instance_class = "db.t3.micro"          # smallest, free tier eligible

  allocated_storage     = 20              # minimum allowed for PostgreSQL
  # max_allocated_storage = <not set>     # disable storage autoscaling
  storage_type          = "gp3"           # cheapest modern SSD

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]

  # Disable backups completely (set to 0)
  backup_retention_period = 0
  backup_window           = null          # not needed if retention is 0

  # Skip final snapshot to avoid storage costs on deletion
  skip_final_snapshot = true

  # Disable deletion protection (so you can destroy easily)
  deletion_protection = false

  # Disable performance insights and enhanced monitoring (both cost extra)
  performance_insights_enabled = false
  monitoring_interval          = 0

  # Disable multi-AZ (single AZ is cheaper)
  multi_az = false

  # No automated maintenance window (optional, but can be left default)
  maintenance_window = "sun:05:00-sun:06:00"   # minimal impact, free

  # Public accessibility must remain false
  publicly_accessible = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-postgres-minimal"
    Environment = var.environment
    Project     = var.project_name
    CostCenter  = "learning"
  }
}
