resource "aws_launch_template" "asg-launch-template" {
  name_prefix   = "asg-launch-template"
  image_id      = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  user_data     = filebase64("userdata.sh")
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }

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

resource "aws_autoscaling_policy" "scale-out" {
  name                   = "asg-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = var.asg_cooldown_seconds
  autoscaling_group_name = aws_autoscaling_group.asg-specs.name
}

resource "aws_autoscaling_policy" "scale-in" {
  name                   = "asg-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = var.asg_cooldown_seconds
  autoscaling_group_name = aws_autoscaling_group.asg-specs.name
}


resource "aws_cloudwatch_metric_alarm" "scale-out-alarm" {
  alarm_name                = "CPU Utilization High"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.cpu_utilization_high_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = var.cpu_utilization_high_period_seconds
  statistic                 = "Average"
  threshold                 = var.cpu_utilization_high_threshold_percent
  
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg-specs.name
  }

  alarm_description = "Scale out if CPU utilization is above ${var.cpu_utilization_high_threshold_percent} for ${var.cpu_utilization_high_period_seconds} * ${var.cpu_utilization_high_evaluation_periods} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale-out.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale-in-alarm" {
  alarm_name                = "CPU Utilization Low"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = var.cpu_utilization_low_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = var.cpu_utilization_low_period_seconds
  statistic                 = "Average"
  threshold                 = var.cpu_utilization_low_threshold_percent
  
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg-specs.name
  }

  alarm_description = "Scale in if the CPU utilization is below ${var.cpu_utilization_low_threshold_percent} for ${var.cpu_utilization_low_period_seconds} * ${var.cpu_utilization_low_evaluation_periods} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale-in.arn]
}
