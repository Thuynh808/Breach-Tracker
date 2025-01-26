variable "aws_region" {
  description = "aws region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "cidr block for the vpc"
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidr" {
  description = "cidr block for the public subnet"
  default     = "10.2.22.0/24"
}

variable "private_subnet_cidr" {
  description = "cidr block for the private subnet"
  default     = "10.2.23.0/24"
}
