variable "project_name" {
  description = "name of the project for tagging and resource naming"
}

variable "vpc_cidr" {
  description = "cidr block for vpc"
}

variable "public_subnet_cidr" {
  description = "cidr blocks public subnet"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "cidr blocks for private subnet"
  type        = list(string)
}

variable "availability_zones" {
  description = "list of availability zones"
  type        = list(string)
}
