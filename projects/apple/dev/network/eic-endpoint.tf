#step-5 adding end point - new step for accessing app
# EC2 Instance Connect Endpoint (costs only when used, free service itself)
resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id          = aws_subnet.private.id   # same AZ as your EC2 (avoids cross-AZ data charges)
  security_group_ids = [aws_security_group.eic.id]

  preserve_client_ip = true   # passes your client IP to the instance's security group

  tags = {
    Name = "${var.project_name}-${var.environment}-eic-endpoint"
  }
}
