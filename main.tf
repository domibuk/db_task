terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#Security Groups
resource "aws_security_group" "demoproject_instance" {
  name   = "demoproject-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.demoproject_lb.id]
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

resource "aws_security_group" "demoproject_lb" {
  name   = "demoproject-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

#EC2
resource "aws_launch_configuration" "demoproject" {
  name_prefix                 = "EC2-asg-"
  image_id                    = var.ami
  instance_type               = "t2.micro"
  user_data                   = file("docker.sh")
  security_groups             = [aws_security_group.demoproject_instance.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

#Autoscaling
resource "aws_autoscaling_group" "demoproject" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = terraform.workspace == "dev" ? 2 : 3
  launch_configuration = aws_launch_configuration.demoproject.name
  vpc_zone_identifier  = var.subnets
}

#Application load balancer
resource "aws_lb" "demoproject" {
  name               = "demoproject-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demoproject_lb.id]
  subnets            = var.subnets
}

resource "aws_lb_listener" "demoproject" {
  load_balancer_arn = aws_lb.demoproject.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demoproject.arn
  }
}

resource "aws_lb_target_group" "demoproject" {
  name     = "demoproject-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_attachment" "demoproject" {
  autoscaling_group_name = aws_autoscaling_group.demoproject.id
  lb_target_group_arn    = aws_lb_target_group.demoproject.arn
}
