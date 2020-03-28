provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "UAT-VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "uat-vpc"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "uat-publicsubnet" {
  vpc_id            = aws_vpc.UAT-VPC.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-west-1a"
  tags = {
    Name = "UAT-VPC-PublicSubnet"
  }
}

/*
  Private Subnet 1
*/
resource "aws_subnet" "uat-privatesubnet-1" {
  vpc_id            = aws_vpc.UAT-VPC.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "eu-west-1b"

  tags = {
    Name = "uat-Privatesubnet-1"
  }
}

/*
  Private Subnet 2
*/
resource "aws_subnet" "uat-privatesubnet-2" {
  vpc_id            = aws_vpc.UAT-VPC.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "eu-west-1c"

  tags = {
    Name = "uat-Privatesubnet-2"
  }
}

resource "aws_internet_gateway" "uat-IGW" {
  vpc_id = aws_vpc.UAT-VPC.id
}

resource "aws_eip" "eip-nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.uat-publicsubnet.id
  depends_on    = [aws_internet_gateway.uat-IGW]
}

/*
  Public Route table
*/

resource "aws_route_table" "uat-publicRT" {
  vpc_id = aws_vpc.UAT-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.uat-IGW.id
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

resource "aws_route_table_association" "uat-vpc-public" {
  subnet_id      = aws_subnet.uat-publicsubnet.id
  route_table_id = aws_route_table.uat-publicRT.id
}

/*
  Private Route table
*/
resource "aws_route_table" "uat-privateRT" {
  vpc_id = aws_vpc.UAT-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "Private Subnet RT"
  }
}

resource "aws_route_table_association" "uat-privatesubnet-1" {
  subnet_id      = aws_subnet.uat-privatesubnet-1.id
  route_table_id = aws_route_table.uat-privateRT.id
}

resource "aws_route_table_association" "uat-privatesubnet-2" {
  subnet_id      = aws_subnet.uat-privatesubnet-2.id
  route_table_id = aws_route_table.uat-privateRT.id
}
