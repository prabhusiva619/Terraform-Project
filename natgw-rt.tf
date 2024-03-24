resource "aws_eip" "elastic_ip_for_nat" {
  depends_on = [aws_internet_gateway.internet-gateway]
  domain = "vpc"
  tags = {
    Name = "elastic_ip_for_nat"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat.id
  subnet_id     = aws_subnet.public_subnet-1.id

  tags = {
    Name = "nat_gateway"
  }

  depends_on = [aws_internet_gateway.internet-gateway]
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.bestseller-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "nat_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.nat_route_table.id
}
