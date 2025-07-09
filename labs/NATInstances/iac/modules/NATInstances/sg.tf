resource "aws_security_group" "nat_sg" {
  name        = var.nat_sg_name
  description = "Allow NAT traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.nat_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_instances" {
  security_group_id = aws_security_group.nat_sg.id
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = var.private_cidr
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_home" {
  security_group_id = aws_security_group.nat_sg.id

  description = "SSH access"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "internet_access" {
  security_group_id = aws_security_group.nat_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_NAT" {
  security_group_id            = var.instance_sg_id
  referenced_security_group_id = aws_security_group.nat_sg.id

  description = "SSH access from NAT Instance"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}
