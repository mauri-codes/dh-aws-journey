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
# Install iptables services
yum install -y iptables-services
systemctl enable iptables
systemctl start iptables

# Enable IP forwarding (persistently)
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

# Flush existing FORWARD rules
iptables -F FORWARD

# 1. Allow return traffic for established connections (must come first)
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# 2. Allow outbound forwarding from private subnet
iptables -A FORWARD -s 10.16.0.0/16 -j ACCEPT

# Set up NAT (masquerade) for outbound traffic using the correct interface
iptables -t nat -A POSTROUTING -s 10.16.0.0/16 -o enX0 -j MASQUERADE

# Save iptables rules for persistence
service iptables save
  EOF

  tags = {
    Name = "NAT_${each.key}"
  }
}

resource "aws_iam_instance_profile" "nat_profile" {
  name = "${var.role_name}IP"
  role = var.role_name
}
