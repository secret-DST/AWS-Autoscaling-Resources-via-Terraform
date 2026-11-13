# Target group for the EC2 instances
resource "aws_lb_target_group" "web_tg" {
  name     = "demo-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Demo Web Target Group"
  }
}

# Internet-facing Application Load Balancer
resource "aws_lb" "demo_alb" {
  name               = "demo-web-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2b.id
  ]

  tags = {
    Name = "Demo Web ALB"
  }
}

# Listen on HTTP and forward requests to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
# Template used to launch EC2 instances
resource "aws_launch_template" "web" {
  name_prefix   = "demo-web-"
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -Ee
    exec > >(tee -a /var/log/user-data.log) 2>&1

    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

    HOSTNAME=$(hostname)

    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>EC2 Auto Scaling Demo</title>
    </head>
    <body>
      <h1>Hello from EC2!</h1>
      <h2>Hostname: $HOSTNAME</h2>
      <p>Apache is running successfully.</p>
    </body>
    </html>
    HTML

    systemctl enable --now apache2
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Demo ASG Web Server"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group manages the EC2 instances
resource "aws_autoscaling_group" "web" {
  name             = "demo-web-asg"
  min_size         = 1
  desired_capacity = 2
  max_size         = 3
  vpc_zone_identifier = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Demo ASG Web Server"
    propagate_at_launch = true
  }

  depends_on = [
    aws_lb_listener.http
  ]
}

