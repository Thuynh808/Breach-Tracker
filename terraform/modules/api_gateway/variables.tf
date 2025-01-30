variable "project_name" {
  description = "Project name for tagging and resource naming"
}

variable "alb_dns_name" {
  description = "ALB DNS name to route traffic"
}

variable "alb_security_group_id" {
  description = "security group id of alb"
}

variable "private_subnet_id" {
  description = "private subnet ids"
  type        = list(string)
}
