# -----------------------------
# Auto Scaling Group
# -----------------------------

resource "aws_autoscaling_group" "web" {
  name = "${var.project_name}-web-asg"

  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size

  vpc_zone_identifier = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      desired_capacity
    ]
  }
}