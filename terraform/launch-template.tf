# -----------------------------
# Latest Amazon Linux 2023 AMI
# -----------------------------

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# -----------------------------
# EC2 Launch Template
# -----------------------------

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  user_data = filebase64("${path.module}/../app/user-data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-web"
      Project = var.project_name
      Role    = "web"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name    = "${var.project_name}-web-volume"
      Project = var.project_name
    }
  }

  tags = {
    Name    = "${var.project_name}-launch-template"
    Project = var.project_name
  }
}