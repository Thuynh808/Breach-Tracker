provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "btvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "breach-tracker-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.btvpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "breach-tracker-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.btvpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "breach-tracker-private-subnet"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "breach-tracker-nat-eip"
  }
}

resource "aws_nat_gateway" "btnat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "breach-tracker-nat-gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.btvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.btnat.id
  }
  tags = {
    Name = "breach-tracker-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_internet_gateway" "btigw" {
  vpc_id = aws_vpc.btvpc.id
  tags = {
    Name = "breach-tracker-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.btvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.btigw.id
  }
  tags = {
    Name = "breach-tracker-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
