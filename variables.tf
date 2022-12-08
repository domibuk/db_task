variable "vpc_id" {
  type    = string
  default = "vpc-371de54e" //change vpc_id to one you are using
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-24a5a06c", "subnet-d96257bf"] //change subnets to ones you are using
}

variable "region" {
  type    = string
  default = "eu-west-1" //change region to one you are using
}

variable "ami" {
  type    = string
  default = "ami-01cae1550c0adea9c" //change AMI to one available in your region
}