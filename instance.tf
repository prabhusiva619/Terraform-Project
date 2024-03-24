resource "aws_instance" "bestseller_ec2_instance" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  user_data = file("userdata.sh")
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  subnet_id = aws_subnet.private_subnet.id

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = "8"
    volume_type           = "gp2"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name = "my_ec2_instance"
  }
}
