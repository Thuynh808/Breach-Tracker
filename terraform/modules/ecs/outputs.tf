# Security group ID for ECS tasks
output "ecs_security_group_id" {
  value       = aws_security_group.ecs_sg.id
  description = "Security group ID for ECS tasks"
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

output "ecr_image_uri" {
  value       = data.aws_ecr_image.service_image.image_uri
  description = "image uri of ecr container image"
}

output "ecs_service" {
  value       = aws_ecs_service.bt_service
  description = "ecs service output"
}
