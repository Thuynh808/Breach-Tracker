variable "project_name" {
  description = "Name of the project for tagging resources"
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
}

variable "private_subnet" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

