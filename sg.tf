resource "aws_security_group" "elb-sg" {
  name   = "elb-sg"
  vpc_id = aws_vpc.bestseller-vpc.id
  
  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
#   ingress {
#     description      = "Allow https request from anywhere"
#     protocol         = "tcp"
#     from_port        = 443
#     to_port          = 443
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "ec2-sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.bestseller-vpc.id

  ingress {
    description     = "Allow http request from Load Balancer"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.elb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
