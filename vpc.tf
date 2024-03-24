resource "aws_vpc" "bestseller-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "bestseller-vpc"
  }
}