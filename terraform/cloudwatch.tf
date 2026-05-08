# -----------------------------
# Auto Scaling Policy: Scale Out
# -----------------------------

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name

  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown           = var.scaling_cooldown_seconds
}

# -----------------------------
# Auto Scaling Policy: Scale In
# -----------------------------

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name

  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown           = var.scaling_cooldown_seconds
}

# -----------------------------
# CloudWatch Alarm: High CPU
# -----------------------------

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu-alarm"
  alarm_description   = "Scale out when average CPU utilization is above ${var.scale_out_cpu_threshold}%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = var.scale_out_cpu_threshold

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  period      = 300
  unit        = "Percent"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]

  tags = {
    Name    = "${var.project_name}-high-cpu-alarm"
    Project = var.project_name
  }
}

# -----------------------------
# CloudWatch Alarm: Low CPU
# -----------------------------

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.project_name}-low-cpu-alarm"
  alarm_description   = "Scale in when average CPU utilization is below ${var.scale_in_cpu_threshold}%"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  threshold           = var.scale_in_cpu_threshold

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  period      = 300
  unit        = "Percent"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]

  tags = {
    Name    = "${var.project_name}-low-cpu-alarm"
    Project = var.project_name
  }
}