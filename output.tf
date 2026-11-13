# Output the public ALB address
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.demo_alb.dns_name
}

data "aws_instances" "web" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.web.name]
  }
}

output "ec2_ids" {
  description = "IDs of EC2 instances in the Auto Scaling Group"
  value       = data.aws_instances.web.ids
}
