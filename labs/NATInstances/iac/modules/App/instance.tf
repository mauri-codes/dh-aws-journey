resource "aws_launch_template" "app_lt" {
  name = var.instance_name

  image_id      = local.ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      bucket_name = var.bucket_name
    })
  )
  key_name = var.key_pair

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name             = "${var.instance_name}ASG"
  desired_capacity = 3
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.public_subnets
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60 # seconds

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.instance_name}TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
