# CloudCampus Stay

## A Highly Available Hotel Booking Web App on AWS

CloudCampus Stay is a hotel booking web application prototype designed for international students and their families visiting U.S. campuses for orientation, move-in, campus tours, family visits, and graduation trips.

This project demonstrates how to deploy a highly available web application on AWS using an internet-facing Application Load Balancer, EC2 instances in private subnets, an Auto Scaling Group across multiple Availability Zones, CloudWatch alarms, layered security groups, and Terraform.

---

## Project Goals

The goal of this project is to build a realistic cloud architecture for a small web application that requires:

- High availability across multiple Availability Zones
- Load balancing through an Application Load Balancer
- EC2 instances deployed in private subnets
- Auto Scaling Group management
- Health checks through an ALB target group
- CPU-based scaling with CloudWatch alarms
- Infrastructure as Code using Terraform

---

## Business Scenario

International students and their families often need short-term accommodation when visiting a U.S. campus for orientation, move-in, campus tours, family visits, or graduation.

CloudCampus Stay simulates a simple hotel booking platform for this scenario. The current version focuses on the AWS infrastructure design rather than full booking business logic.

Future versions could add a backend API, database integration, user authentication, and a real booking workflow.

---

## Architecture Overview

Users access the application through an internet-facing Application Load Balancer deployed in public subnets. The ALB forwards HTTP traffic to EC2 web servers running in private subnets across two Availability Zones.

The EC2 instances are launched and managed by an Auto Scaling Group. The ALB target group performs health checks against the `/health` endpoint on each EC2 instance. CloudWatch alarms monitor average CPU utilization and trigger Auto Scaling policies.

```text
Internet Users
      |
      v
Application Load Balancer
Public Subnet A + Public Subnet B
      |
      v
Target Group
      |
      v
Auto Scaling Group
      |
      +--> EC2 Web Server in Private Subnet A
      |
      +--> EC2 Web Server in Private Subnet B
      |
      v
CloudWatch Alarms + Auto Scaling Policies
