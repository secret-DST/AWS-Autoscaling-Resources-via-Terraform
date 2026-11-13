# security group for public load balancer
resource "aws_security_group" "alb_sg" {
  name        = "demo-alb-sg"
  description = "allow http traffic to the ALB"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "HTTP from the internet"
    from_port   = var.http[0]
    to_port     = var.http[0]
    protocol    = var.http[1]
    cidr_blocks = [var.cidr_blocks[3]]
  }

  egress {
    from_port   = var.egress[0]
    to_port     = var.egress[0]
    protocol    = var.egress[1]
    cidr_blocks = [var.cidr_blocks[3]]
  }

  tags = {
    Name = "Demo ALB SG"
  }
}

# Security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "demo-ec2-sg"
  description = "allow http only from ALB"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = var.http[0]
    to_port         = var.http[0]
    protocol        = var.http[1]
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = var.egress[0]
    to_port     = var.egress[0]
    protocol    = var.egress[1]
    cidr_blocks = [var.cidr_blocks[3]]
  }

  tags = {
    "Name" = "Demo EC2 SG"
  }
}

