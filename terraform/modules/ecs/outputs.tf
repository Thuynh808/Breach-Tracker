# Security group ID for ECS tasks
output "ecs_security_group_id" {
  value       = aws_security_group.ecs_sg.id
  description = "Security group ID for ECS tasks"
}

# URL of the ECR repository
output "ecr_repository_url" {
  value       = aws_ecr_repository.bt_ecr.repository_url
  description = "The URL of the ECR repository"
}

# Name of the ECS cluster
output "ecs_cluster_name" {
  value       = aws_ecs_cluster.bt_cluster.name
  description = "The name of the ECS cluster"
}

# ARN of the ECS task definition
output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.bt_task.arn
  description = "The ARN of the ECS task definition"
}

# Name of the ECS service
output "ecs_service_name" {
  value       = aws_ecs_service.bt_service.name
  description = "The name of the ECS service"
}

