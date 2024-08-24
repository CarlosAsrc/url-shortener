# main.tf
// App setup and tagging:
provider "aws" {
  profile = "default"
  region = "us-east-1"
  alias = "application"
}

resource "aws_servicecatalogappregistry_application" "url_shortener" {
  provider    = aws.application
  name        = "UrlShortener"
  description = "Simple URL Shortener application"
}

provider "aws" {
  default_tags {
    tags = aws_servicecatalogappregistry_application.url_shortener.application_tag
  }
}

// NETWORKFING:
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

  ingress {
    from_port   = 22
    to_port     = 22
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

// EC2 and ECR Permissions:
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "ecr_dynamodb_access_policy" {
  name   = "ecr_dynamodb_access_policy"
  role   = aws_iam_role.ec2_instance_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken"
      ]
      Resource = "*"
    },
    {
        Effect   = "Allow"
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.url_table.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_instance_role.name
}


// DynamoDB:
resource "aws_dynamodb_table" "url_table" {
  name           = "url-development"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "shortUrl"

  global_secondary_index {
    name               = "LongUrlIndex"
    hash_key           = "longUrl"
    projection_type    = "ALL"

    read_capacity  = 10
    write_capacity = 10
  }

    global_secondary_index {
    name               = "CreatedAtIndex"
    hash_key           = "createdAt"
    projection_type    = "ALL"

    read_capacity  = 5
    write_capacity = 5
  }

  global_secondary_index {
    name               = "AccessCountIndex"
    hash_key           = "accessCount"
    projection_type    = "ALL"

    read_capacity  = 5
    write_capacity = 5
  }

  attribute {
    name = "shortUrl"
    type = "S"
  }

  attribute {
    name = "longUrl"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "accessCount"
    type = "N"
  }
}


// EC2 Instance:
resource "aws_instance" "golang_app" {
  ami             = "ami-0ba9883b710b05ac6"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.url_shortener_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 446343335231.dkr.ecr.us-east-1.amazonaws.com
              docker run -d -p 8080:8080 446343335231.dkr.ecr.us-east-1.amazonaws.com/url_shortener_images:latest
              EOF
}

output "public_ip" {
  value = aws_instance.golang_app.public_ip
}
