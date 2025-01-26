output "vpc_id" {
  value       = aws_vpc.btvpc.id
  description = "The ID of the VPC."
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "The ID of the public subnet."
}

output "private_subnet_id" {
  value       = aws_subnet.private.id
  description = "The ID of the private subnet."
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.btnat.id
  description = "The ID of the NAT Gateway."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.btigw.id
  description = "The ID of the Internet Gateway."
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "The ID of the private route table."
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "The ID of the public route table."
}

