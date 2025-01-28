output "vpc_id" {
  value       = aws_vpc.bt_vpc.id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "public subnet id"
}

output "private_subnet_id" {
  value       = aws_subnet.private.id
  description = "private subnet id"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.bt_nat.id
  description = "nat gateway id"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.bt_igw.id
  description = "internet gateway id"
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "private route table id"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "public route table id"
}

