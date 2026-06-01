#step-4 adding ec2 instance

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
}

# The EC2 instance running the application
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.web_security_group_id]
  key_name               = var.key_name

  # User data script to bootstrap the application
  user_data = <<-EOF
    #!/bin/bash
    # Update system and install Git, Python, and pip
    yum update -y
    yum install -y git python3 python3-pip

    # Clone the application repository (using the one from your previous steps)
    git clone https://github.com/akhileshmishrabiz/Devops-zero-to-hero.git /home/ec2-user/app
    cd /home/ec2-user/app

    # Install application dependencies
    pip3 install -r requirements.txt

    # Run the application (this example uses Flask, adjust as needed)
    FLASK_APP=app.py flask run --host=0.0.0.0 --port=8080 &
    EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-ec2"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
