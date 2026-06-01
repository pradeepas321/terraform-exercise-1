#step 3 create databases 
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_id" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.main.id
}
