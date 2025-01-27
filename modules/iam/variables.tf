variable "project_name" {
  description = "name of the project for resource tagging"
}

variable "ecs_task_execution_policy" {
  description = "arn of ECS Task Execution Policy"
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

