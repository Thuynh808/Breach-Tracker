variable "project_name" {
  description = "Name of the project for tagging and resource naming"
  type        = string
}

variable "vpc_id" {
  description = "vpc id for ecs services"
  type        = string
}

variable "private_subnet_cidr" {
  description = "private subnet cidrs"
  type        = list(string)
}

variable "private_subnet_id" {
  description = "private subnet ids"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the target group for alb"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "arn of execution role for ecs"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "arn of task role for ecs"
  type        = string
}

variable "ecr_repository_name" {
  description = "name of ecr repository"
  type        = string
}
