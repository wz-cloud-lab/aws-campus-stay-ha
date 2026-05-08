# -----------------------------
# Security Group for ALB
# -----------------------------

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP traffic from the internet to the Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-alb-sg"
    Project = var.project_name
  }
}

# Allow HTTP traffic from the internet to ALB
resource "aws_vpc_security_group_ingress_rule" "alb_http_from_internet" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from the internet"
}

# Allow ALB to forward HTTP traffic to EC2 instances
resource "aws_vpc_security_group_egress_rule" "alb_http_to_ec2" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.ec2.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  description = "Allow HTTP from ALB to EC2 instances"
}

# -----------------------------
# Security Group for EC2 Web Servers
# -----------------------------

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow HTTP traffic only from the ALB security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-ec2-sg"
    Project = var.project_name
  }
}

# Allow HTTP traffic from ALB only
resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  description = "Allow HTTP from ALB security group only"
}

# Allow outbound traffic from EC2
resource "aws_vpc_security_group_egress_rule" "ec2_all_outbound" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic from EC2 instances"
}