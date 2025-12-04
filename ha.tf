resource "aws_launch_template" "app_lt" {
  name_prefix = "app-template"

  image_id = "ami-0c768662cc797cd75"
  instance_type = "t2.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
echo "<h1>ASG Web Server</h1>" > /usr/share/nginx/html/index.html
EOF
)
}

resource "aws_lb" "alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [module.network.public_a, module.network.public_b]
}

resource "aws_lb_target_group" "tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "app-asg"
  max_size            = 4
  min_size            = 2
  desired_capacity    = 2

  vpc_zone_identifier = [
    module.network.private_a,
    module.network.private_b
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
}
