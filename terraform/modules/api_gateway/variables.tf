variable "project_name" {
  description = "Project name for tagging and resource naming"
}

variable "vpc_id" {
  description = "id of vpc"
}

variable "alb_listener_arn" {
  description = "arn of ALB listener "
}

variable "alb_security_group_id" {
  description = "security group id of alb"
  type        = list(string)
}

variable "private_subnet_id" {
  description = "private subnet ids"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "allowed cidr blocks of public api endpoints"
  type        = list(string)
}
