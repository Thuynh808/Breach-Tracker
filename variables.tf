variable "project_name" {
  description = "name of the project for tagging and resource naming"
}

variable "aws_region" {
  description = "aws region to deploy resources"
}

variable "vpc_cidr" {
  description = "cidr block for the vpc"
}

variable "public_subnet_cidr" {
  description = "cidr block for the public subnet"
}

variable "private_subnet_cidr" {
  description = "cidr block for the private subnet"
}
