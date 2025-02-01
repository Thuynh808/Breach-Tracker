variable "project_name" {
  description = "Name of the project for tagging and resource naming"
  type        = string
}

variable "vpc_id" {
  description = "vpc id for ecs services"
}

# Subnets for ECS service
variable "private_subnet_cidr" {
  description = "List of subnets where ECS tasks will be deployed"
  type        = list(string)
}

variable "private_subnet_id" {
  description = "List of subnets where ECS tasks will be deployed"
  type        = list(string)
}

# Security groups for ECS tasks
variable "alb_security_group_id" {
  description = "List of security groups for ECS tasks"
}

# ALB target group ARN for the ECS service
variable "alb_target_group_arn" {
  description = "ARN of the target group for ALB to route traffic to ECS tasks"
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
