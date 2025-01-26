# Provider Configuration
provider "aws" {
  region = var.aws_region
}


# VPC Module
module "vpc" {
  source = "./vpc"
}

# ECS Module
module "ecs" {
  source = "./ecs"
}

# ALB Module
module "alb" {
  source = "./alb"
}

# API Gateway Module
module "api_gateway" {
  source = "./api_gateway"
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

