resource "aws_security_group" "instance_sg" {
  name        = var.instance_sg_name
  description = "Allow HTTP inbound traffic and outbound traffic to NAT instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.instance_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_alb" {
  count                        = var.is_solution ? 1 : 0
  security_group_id            = aws_security_group.instance_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "from_alb2" {
  count             = var.is_solution ? 0 : 1
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "internet_access" {
  security_group_id = aws_security_group.instance_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_security_group" "alb_sg" {
  name   = var.alb_sg_name
  vpc_id = var.vpc_id
  tags = {
    Name = var.alb_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_inbound" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
