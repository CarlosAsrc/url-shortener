# main.tf
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "url_shortener_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.url_shortener_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "golang_app" {
  ami             = "ami-0ba9883b710b05ac6"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.url_shortener_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "GolangAppInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 8080:8080 446343335231.dkr.ecr.us-east-1.amazonaws.com/url_shortener_images:latest
              EOF
}

output "public_ip" {
  value = aws_instance.golang_app.public_ip
}
