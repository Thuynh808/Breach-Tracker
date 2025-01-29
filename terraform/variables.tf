variable "project_name" {
  description = "name of the project for tagging and resource naming"
}

variable "aws_region" {
  description = "aws region to deploy resources"
}

variable "vpc_cidr" {
  description = "vpc cidr for resources"
}

variable "public_subnet_cidr" {
  description = "public subnet cidr block for nat gateway"
}

variable "private_subnet_cidr" {
  description = "private subnet cidr block for ecs/alb"
}

variable "availability_zones" {
  description = "availability_zones"
}

variable "allowed_cidrs" {
  description = "aws api_gateway public cidrs"
  type        = list(string)
}
