variable "project_name" {
  description = "name of the project for tagging and resource naming"
}

variable "vpc_cidr" {
  description = "cidr block for vpc"
}

variable "public_subnet_cidr" {
  description = "cidr block public subnet"
}

variable "private_subnet_cidr" {
  description = "cidr block for private subnet"
}
