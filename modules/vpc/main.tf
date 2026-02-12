####################################
# VPC
####################################
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

####################################
# PUBLIC SUBNETS (2 AZ)
####################################
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidr_1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidr_2
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-2"
  }
}

####################################
# PRIVATE SUBNETS (MATCH AZs)
####################################
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_cidr_1
  availability_zone = var.az_1

  tags = {
    Name = "${var.vpc_name}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_cidr_2
  availability_zone = var.az_2

  tags = {
    Name = "${var.vpc_name}-private-2"
  }
}

####################################
# INTERNET GATEWAY
####################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

####################################
# PUBLIC ROUTE TABLE
####################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

####################################
# NAT GATEWAY (in public subnet)
####################################
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.this]
}

####################################
# PRIVATE ROUTE TABLE
####################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
