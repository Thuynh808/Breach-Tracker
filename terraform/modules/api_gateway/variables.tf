variable "project_name" {
  description = "Project name for tagging and resource naming"
}

variable "vpc_id" {
  description = "id of vpc"
}

variable "alb_listener_arn" {
  description = "arn of ALB listener "
}

variable "private_subnet_id" {
  description = "private subnet ids"
  type        = list(string)
}

variable "ecs_service" {
  description = "confirm ecs service before deploying"
}
