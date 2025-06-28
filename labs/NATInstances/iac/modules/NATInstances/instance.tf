resource "aws_instance" "nat" {
  for_each = local.nat_subnets

  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  associate_public_ip_address = true
  key_name = var.key_pair
  source_dest_check    = false
  iam_instance_profile = aws_iam_instance_profile.nat_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y iptables-services
    sudo systemctl enable iptables
    sudo systemctl start iptables

    sudo touch /etc/sysctl.d/custom-ip-forwarding.conf
    sudo echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/custom-ip-forwarding.conf
    sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

    sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    sudo /sbin/iptables -F FORWARD
    sudo service iptables save
  EOF

  tags = {
    Name = "NAT_${each.key}"
  }
}

resource "aws_iam_instance_profile" "nat_profile" {
  name = "NAT_Profile"
  role = var.role_name
}
