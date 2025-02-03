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

output "public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "route table for public subnet"
}

output "private_route_table_id" {
  value       = module.vpc.private_route_table_id
  description = "route table for private subnet"
}

output "ecs_task_execution_role_arn" {
  value       = module.iam.ecs_task_execution_role_arn
  description = "ecs task execution role arn"
}

output "alb_target_group_arn" {
  value       = module.alb.alb_target_group_arn
  description = "target group arn for ecs"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "dns name for alb"
}

output "alb_arn" {
  value       = module.alb.alb_arn
  description = "arn for alb"
}

output "ecs_security_group_id" {
  value       = module.ecs.ecs_security_group_id
  description = "security group for ecs"
}

output "alb_listener_arn" {
  value       = module.alb.alb_listener_arn
  description = "alb listener arn"
}

output "ecr_image_uri" {
  value       = module.ecs.ecr_image_uri
  description = "ecr image url"
}

output "ecs_cluster_name" {
  value       = module.ecs.ecs_cluster_name
  description = "cluster name"
}

output "ecs_task_definition_arn" {
  value       = module.ecs.ecs_task_definition_arn
  description = "arn of ecs task definition"
}

output "ecs_service_name" {
  value       = module.ecs.ecs_service_name
  description = "ecs service name"
}

output "api_endpoint" {
  value       = "${module.api_gateway.api_endpoint}breaches"
  description = "url endpoint of api gateway"
}

output "vpc_link_sg_id" {
  value       = module.api_gateway.vpc_link_sg_id
  description = "security group id of vpc link"
}

output "api_id" {
  value       = module.api_gateway.api_id
  description = "id of api"
}
