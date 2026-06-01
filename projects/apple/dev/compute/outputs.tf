#step-4 adding ec2 instances 

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app.id
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.app.private_ip
}
