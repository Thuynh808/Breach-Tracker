provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  alb_arn      = module.alb.alb_arn
}

module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_id   = module.vpc.private_subnet_id
}

module "ecs" {
  source                      = "./modules/ecs"
  project_name                = var.project_name
  vpc_id                      = module.vpc.vpc_id
  private_subnet_cidr         = var.private_subnet_cidr
  private_subnet_id           = module.vpc.private_subnet_id
  alb_target_group_arn        = module.alb.alb_target_group_arn
  alb_security_group_id       = module.alb.alb_security_group_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  ecr_repository_name         = var.ecr_repository_name
}

module "api_gateway" {
  source                = "./modules/api_gateway"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  alb_listener_arn      = module.alb.alb_listener_arn
  alb_security_group_id = module.alb.alb_security_group_id
  private_subnet_id     = module.vpc.private_subnet_id
}

