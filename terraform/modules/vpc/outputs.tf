output "vpc_id" {
  value       = aws_vpc.bt_vpc.id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = aws_subnet.public[*].id
  description = "public subnet ids"
}

output "private_subnet_id" {
  value       = aws_subnet.private[*].id
  description = "private subnet ids"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.bt_nat[*].id
  description = "nat gateway ids"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.bt_igw.id
  description = "internet gateway id"
}

output "public_route_table_id" {
  value       = aws_route_table.public[*].id
  description = "route table for public subnet"
}

output "private_route_table_id" {
  value       = aws_route_table.public[*].id
  description = "route table for public subnet"
}

