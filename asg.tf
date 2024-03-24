resource "aws_launch_template" "asg-launch-template" {
  name_prefix   = "asg-launch-template"
  image_id      = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  user_data     = file("userdata.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.private_subnet.id
    security_groups             = [aws_security_group.ec2-sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my_ec2_instance"
    }
  }
}

resource "aws_autoscaling_group" "asg-specs" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  target_group_arns = [aws_lb_target_group.lb-target-group.arn]

  vpc_zone_identifier = [
    aws_subnet.private_subnet.id
  ]

  launch_template {
    id      = aws_launch_template.asg-launch-template.id
    version = "$Latest"
  }
}
