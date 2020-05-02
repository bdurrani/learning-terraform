# This probably doesn't work
provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.59.0"
}

# module "lambda_vpc" {
#   source = "../../modules/vpc"
# }

resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "lambda-vpc"
  }
}

resource "aws_subnet" "lambda-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "lambda-subnet-1"
  }
}

resource "aws_subnet" "lambda-subnet-public-2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "lambda-subnet-2"
  }
}

resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block                = "172.31.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id

  }

  tags = {
    Name = "prod-public-rt"
  }
}

resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block                = "172.31.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id

  }

  tags = {
    Name = "prod-public-crt"
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.lambda-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

// https://www.terraform.io/docs/providers/aws/r/vpc_peering_connection.html
resource "aws_vpc_peering_connection" "peering_connection" {
  # peer_owner_id = var.peer_owner_id
  peer_vpc_id = aws_vpc.prod-vpc.id
  vpc_id      = aws_default_vpc.default.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "VPC Peering between prod_vpc and default"
  }
}
