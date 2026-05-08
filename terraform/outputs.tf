output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "availability_zones" {
  description = "Availability Zones used by this project"
  value = [
    aws_subnet.public_a.availability_zone,
    aws_subnet.public_b.availability_zone
  ]
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security group ID for the EC2 web servers"
  value       = aws_security_group.ec2.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.web.arn
}

output "target_group_name" {
  description = "Name of the ALB target group"
  value       = aws_lb_target_group.web.name
}

output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.web.id
}

output "launch_template_latest_version" {
  description = "Latest version of the EC2 launch template"
  value       = aws_launch_template.web.latest_version
}

output "amazon_linux_2023_ami_id" {
  description = "Amazon Linux 2023 AMI ID used by the launch template"
  value       = nonsensitive(data.aws_ssm_parameter.amazon_linux_2023.value)
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.arn
}

output "scale_out_policy_arn" {
  description = "ARN of the scale-out Auto Scaling policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of the scale-in Auto Scaling policy"
  value       = aws_autoscaling_policy.scale_in.arn
}

output "high_cpu_alarm_name" {
  description = "Name of the high CPU CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "low_cpu_alarm_name" {
  description = "Name of the low CPU CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.low_cpu.alarm_name
}