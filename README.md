# AWS EC2 Auto Scaling with Application Load Balancer via Terraform

## Architecture
<img width="912" height="530" alt="Screenshot 2026-08-14 115934" src="https://github.com/user-attachments/assets/7f19fd4c-e8f9-4f8f-8721-44c1f41fa8c5" />

## Overview
This project provisions a highly available web application infrastructure on AWS using **Terraform**.

It creates a custom VPC with public subnets across two Availability Zones, an Internet Gateway, security groups, an Application Load Balancer (ALB), and an Auto Scaling Group (ASG) that manages EC2 instances running Apache HTTP Server.

The Application Load Balancer distributes incoming HTTP traffic across EC2 instances, while the Auto Scaling Group maintains the desired number of instances and automatically replaces unhealthy instances.

## Infrastructure Components

- **VPC:** Custom Virtual Private Cloud for isolating AWS resources.
- **Public Subnets:** Two public subnets deployed across different Availability Zones (`eu-west-2a` and `eu-west-2b`).
- **Internet Gateway:** Provides internet connectivity to resources in the public subnets.
- **Route Table:** Routes internet-bound traffic through the Internet Gateway.
- **Security Groups:** Controls inbound and outbound traffic for the ALB and EC2 instances.
- **Application Load Balancer:** Distributes incoming HTTP traffic across registered EC2 instances.
- **Target Group:** Registers EC2 instances and performs health checks.
- **Launch Template:** Defines the EC2 instance configuration, including AMI, instance type, security groups, and user data.
- **Auto Scaling Group:** Automatically manages EC2 instances across both Availability Zones.
- **Apache Web Server:** Installed automatically using EC2 user data.

## Traditional VS Modern Architchture
<img width="870" height="491" alt="AutoScaling" src="https://github.com/user-attachments/assets/1aaeb831-25d0-4cbe-aaf3-a3ef0fc90a70" />


## AWS Resources Created

| Resource | Terraform Resource | Description |
|---|---|---|
| VPC | `aws_vpc` | Creates a custom VPC |
| Internet Gateway | `aws_internet_gateway` | Enables internet connectivity |
| Public Subnets | `aws_subnet` | Creates two public subnets |
| Route Table | `aws_route_table` | Routes traffic to the internet |
| Route Associations | `aws_route_table_association` | Associates public subnets with the route table |
| ALB Security Group | `aws_security_group.alb_sg` | Allows HTTP traffic from the internet |
| EC2 Security Group | `aws_security_group.ec2_sg` | Allows HTTP traffic from the ALB |
| Target Group | `aws_lb_target_group` | Registers EC2 instances and checks their health |
| Application Load Balancer | `aws_lb` | Distributes incoming requests |
| ALB Listener | `aws_lb_listener` | Listens on HTTP port 80 |
| Launch Template | `aws_launch_template` | Defines EC2 instance configuration |
| Auto Scaling Group | `aws_autoscaling_group` | Maintains and scales EC2 instances |

## Project Structure

```text
.
├── main.tf
├── povider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── asg_alb.tf
├── security_groups.tf
└── README.md
```

## Future Improvements

Potential improvements to this infrastructure include:

- Add HTTPS support using AWS Certificate Manager (ACM).
- Configure an Auto Scaling policy based on CPU utilization.
- Deploy EC2 instances in private subnets.
- Use NAT Gateway for outbound internet access from private subnets.
- Store Terraform state remotely using Amazon S3 with state locking.
- Implement monitoring and alarms using Amazon CloudWatch.
- Restrict administrative access using AWS Systems Manager Session Manager.
- Use Terraform modules to improve code reusability.

## Technologies Used

- **AWS**
- **Terraform**
- **Amazon EC2**
- **Amazon S3**
- **Amazon VPC**
- **Application Load Balancer**
- **Auto Scaling Group**
- **Security Groups**
- **Apache HTTP Server**
- **AWS CLI**
- **Bash**

## Author

Created as an Infrastructure as Code (IaC) project to demonstrate AWS networking, load balancing, EC2 provisioning, and automated scaling using Terraform.
