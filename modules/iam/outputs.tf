output "ecs_task_executionrole_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN of the ECS Task Execution Role"
}

