//A file to create network and security settings

//create a vpc
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

//create two subnets for AZs
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    name = "public_subnet_b"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "subnet_association1" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.routetable.id
}

resource "aws_route_table_association" "subnet_association2" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.routetable.id
}

