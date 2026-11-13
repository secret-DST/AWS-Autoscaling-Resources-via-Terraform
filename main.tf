resource "aws_vpc" "demo" {
  cidr_block       = var.cidr_blocks[0]
  instance_tenancy = "default"

  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "Demo igw"
  }
}

resource "aws_subnet" "public_2a" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.cidr_blocks[1]
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet 2a"
  }
}

resource "aws_subnet" "public_2b" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.cidr_blocks[2]
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet 2b"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = var.cidr_blocks[3]
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = {
    Name = "Public RT"
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = {
    public_2a = aws_subnet.public_2a.id
    public_2b = aws_subnet.public_2b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

