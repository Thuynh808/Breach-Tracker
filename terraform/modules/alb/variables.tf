variable "project_name" {
  description = "Name of the project for tagging resources"
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
}

variable "private_subnet_id" {
  description = "private subnet ids for the ALB"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of private subnets for the ALB"
  type        = list(string)
}
