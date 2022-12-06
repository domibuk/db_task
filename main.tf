terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

###Security Groups###
resource "aws_security_group" "db-app-sg" {
  name   = "db-app-sg"
  vpc_id = "vpc-371de54e"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = []
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name : "db-app-sg"
  }
}

###EC2###
resource "aws_instance" "db-app-instance" {
  ami           = "ami-01cae1550c0adea9c"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.db-app-sg.id]

  user_data = file("docker.sh")
  
  tags = {
    Name = "DbDockerInstance"
  }

}