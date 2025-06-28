resource "aws_lb" "app_alb" {
  name               = "${var.instance_name}LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}
