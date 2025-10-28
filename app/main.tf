
provider "aws" {
  region = "ca-central-1"
}

# Fetch current public IP for security group CIDR
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Query latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Restrict HTTP access to current IP only
resource "aws_security_group" "web_access" {
  name        = "allow-web-traffic"
  description = "Allow inbound HTTP traffic on port 80 from my IP"

  ingress {
    description = "HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowWebTraffic"
  }
}

# Web server instance with Nginx bootstrap
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web_access.id]

  # Bootstrap script - installs and configures Nginx on first boot
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "MyEC2Instance"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "nginx_url" {
  description = "URL to access Nginx web server"
  value       = "http://${aws_instance.example.public_ip}"
}