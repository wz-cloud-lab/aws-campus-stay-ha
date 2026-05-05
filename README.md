# CloudCampus Stay

## A Highly Available Hotel Booking Web App on AWS

CloudCampus Stay is a hotel booking web application prototype designed for international students and their families visiting U.S. campuses for orientation, move-in, campus tours, family visits, and graduation.

This project demonstrates how to deploy a highly available web application on AWS using an internet-facing Application Load Balancer, EC2 instances in private subnets, an Auto Scaling Group across multiple Availability Zones, layered security groups, CloudWatch alarms, and Terraform.

## Architecture Overview

Internet users access the application through an internet-facing Application Load Balancer deployed in public subnets. The ALB forwards traffic to EC2 web servers running in private subnets across two Availability Zones. An Auto Scaling Group maintains the desired number of instances and replaces unhealthy instances automatically.

## AWS Services Used

- Amazon VPC
- Public and private subnets
- Internet Gateway
- Amazon EC2
- Launch Template
- Auto Scaling Group
- Application Load Balancer
- Target Group
- Security Groups
- Amazon CloudWatch
- Terraform

## Key Design Decisions

### Why the ALB is deployed in public subnets

The Application Load Balancer is internet-facing and must be reachable by external users. Therefore, it is deployed in public subnets with a route to the Internet Gateway.

### Why EC2 instances are deployed in private subnets

The EC2 web servers do not need to be directly accessible from the internet. They are placed in private subnets and only accept HTTP traffic from the ALB security group.

### Why the Auto Scaling Group spans multiple Availability Zones

The Auto Scaling Group launches EC2 instances across multiple Availability Zones to improve availability and reduce the impact of a single AZ failure.

### How security groups are layered

The ALB security group allows inbound HTTP traffic from the internet. The EC2 security group allows inbound HTTP traffic only from the ALB security group.

### How health checks work

The ALB target group checks the `/health` endpoint on each EC2 instance. If an instance becomes unhealthy, the ALB stops sending traffic to it.

### How CloudWatch supports Auto Scaling

CloudWatch monitors metrics such as average CPU utilization. Scaling policies can increase or decrease the number of EC2 instances based on defined thresholds.

## Application Features

- Hotel landing page for international students and families
- Room type cards
- Booking request form prototype
- Instance ID and Availability Zone displayed on the page
- Health check endpoint

## Future Improvements

- Add Amazon RDS for booking data
- Add HTTPS with ACM and Route 53
- Add a backend API
- Add CI/CD with GitHub Actions
- Add monitoring dashboard
- Add AWS Systems Manager Session Manager for private instance access
