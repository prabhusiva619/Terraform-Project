resource "aws_internet_gateway" "internet-gateway" {
 vpc_id = aws_vpc.bestseller-vpc.id
 
 tags = {
   Name = "internet-gateway"
 }
}

resource "aws_route_table" "route-table" {
 vpc_id = aws_vpc.bestseller-vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet-gateway.id
 }
 
 tags = {
   Name = "route-table"
 }
}

resource "aws_route_table_association" "public_subnet_rt_association_1" {
 subnet_id      = aws_subnet.public_subnet-1.id
 route_table_id = aws_route_table.route-table.id
}

resource "aws_route_table_association" "public_subnet_rt_association_2" {
 subnet_id      = aws_subnet.public_subnet-2.id
 route_table_id = aws_route_table.route-table.id
}
