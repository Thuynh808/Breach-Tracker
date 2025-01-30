project_name        = "breach-tracker"
aws_region          = "us-east-1"
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidr  = ["10.2.22.0/24", "10.2.24.0/24"]
private_subnet_cidr = ["10.2.23.0/24", "10.2.25.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b"]
allowed_cidrs = [
  "3.216.135.0/24",
  "3.216.136.0/21",
  "3.216.144.0/23",
  "3.216.148.0/22",
  "3.235.26.0/23",
  "3.235.32.0/21",
  "3.238.166.0/24",
  "3.238.212.0/22",
  "44.206.4.0/22",
  "44.210.64.0/22",
  "44.212.176.0/23",
  "44.212.178.0/23",
  "44.212.180.0/23",
  "44.212.182.0/23",
  "44.218.96.0/23",
  "44.220.28.0/22"
]

ecr_repository_name = "breach-tracker"
