#step 2.3, after adding igw, eip and nat gw and adding route tables, you add security groups

# Security Group for App EC2 (allows SSH, HTTP, HTTPS from anywhere)
resource "aws_security_group" "web" {
  name        = "apple_dev_web_sg"
  description = "Allow SSH, HTTP, HTTPS access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#i don think this is required but adding it anyway as part of step-5
  ingress {
    description     = "SSH from EIC endpoint"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eic.id]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask app from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apple_dev_web_sg"
  }
}

# Security Group for RDS (allows PostgreSQL from the web security group only)
resource "aws_security_group" "rds" {
  name        = "apple_dev_rds_sg"
  description = "Allow database access from web security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from web SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # If you use MySQL (3306) or other database ports, add them here similarly.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apple_dev_rds_sg"
  }
}

#step-5 adding end point security groups

# Security group for the EIC endpoint itself
resource "aws_security_group" "eic" {
  name        = "${var.project_name}-${var.environment}-eic-sg"
  description = "Allow SSH from my IP to the endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]   # variable you'll define (see step 4)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eic-sg"
  }
}
