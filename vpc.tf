#A file to create network and security settings

#vpc creation
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

#two subnets in different AZs
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

#Creation of an internet gateway to allow access to the internet
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

#Routing table to add a custom route to all IP addresses, to pull the GitHub repository from the instance
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

#Assigned route table to the subnets
resource "aws_route_table_association" "subnet_association1" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.routetable.id
}

resource "aws_route_table_association" "subnet_association2" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.routetable.id
}

