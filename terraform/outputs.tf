output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "id of vpc"
}

output "public_subnet_id" {
  value       = module.vpc.public_subnet_id
  description = "id of public subnet"
}

output "private_subnet_id" {
  value       = module.vpc.private_subnet_id
  description = "id of private subnet"
}

output "nat_gateway_id" {
  value       = module.vpc.nat_gateway_id
  description = "nat gateway id"
}

output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
  description = "internet gateway id"
}

output "private_route_table_id" {
  value       = module.vpc.private_route_table_id
  description = "private route table id"
}

output "public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "public route table id"
}

output "ecs_task_execution_role_arn" {
  value       = module.iam.ecs_task_executionrole_arn
  description = "ecs task execution role arn"
}
