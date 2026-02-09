############################################
# VPC
############################################
resource "aws_vpc" "bedrock" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = local.vpc_name_tag
    Project = local.project_tag
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

############################################
# Subnets
############################################
# Public subnets (auto-assign public IPs)
resource "aws_subnet" "public" {
  count = length(local.public_subnet_cidrs)

  vpc_id                  = aws_vpc.bedrock.id
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${local.cluster_name}-public-${count.index + 1}"
    Project = local.project_tag
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(local.private_subnet_cidrs)

  vpc_id                  = aws_vpc.bedrock.id
  cidr_block              = local.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name    = "${local.cluster_name}-private-${count.index + 1}"
    Project = local.project_tag
  }
}

############################################
# Internet Gateway
############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Name    = "${local.cluster_name}-igw"
    Project = local.project_tag
  }
}

############################################
# NAT Gateway (in public subnet 0)
############################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "${local.cluster_name}-nat-eip"
    Project = local.project_tag
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name    = "${local.cluster_name}-nat"
    Project = local.project_tag
  }

  depends_on = [aws_internet_gateway.igw]
}

############################################
# Route Tables
############################################
# Public route table -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Name    = "${local.cluster_name}-public-rt"
    Project = local.project_tag
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route table -> NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Name    = "${local.cluster_name}-private-rt"
    Project = local.project_tag
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
