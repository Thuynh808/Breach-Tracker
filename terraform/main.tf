provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  private_subnet = [module.vpc.private_subnet_id]
  allowed_cidrs  = [] # no direct public access; api gateway will route traffic
}

module "ecs" {
  source                = "./modules/ecs"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet        = [module.vpc.private_subnet_id]
  alb_target_group_arn  = module.alb.alb_target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
}
