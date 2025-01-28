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

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

