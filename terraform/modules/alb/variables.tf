variable "project_name" {
  description = "Name of the project for tagging resources"
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
}

variable "vpc_cidr" {
  description = "vpc cidr"
}

variable "private_subnet_id" {
  description = "private subnet ids for the ALB"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of private subnets for the ALB"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "security group id for ecs and alb"
  type        = string
}
