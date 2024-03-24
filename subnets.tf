resource "aws_subnet" "public_subnet-1" {
 vpc_id     = aws_vpc.bestseller-vpc.id
 cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "us-east-1a"
 
 tags = {
   Name = "public-subnet-1"
 }
}

resource "aws_subnet" "public_subnet-2" {
 vpc_id     = aws_vpc.bestseller-vpc.id
 cidr_block = "10.0.2.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "us-east-1b"
 
 tags = {
   Name = "public-subnet-2"
 }
}
 
resource "aws_subnet" "private_subnet" {
 vpc_id     = aws_vpc.bestseller-vpc.id
 cidr_block = "10.0.3.0/24"
 availability_zone = "us-east-1a"
 
 tags = {
   Name = "private-subnet"
 }
}