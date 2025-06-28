resource "aws_route" "nat_a" {
  route_table_id         = var.route_table_a_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat["A"].primary_network_interface_id
}
resource "aws_route" "nat_b" {
  route_table_id         = var.route_table_b_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat["B"].primary_network_interface_id
}
resource "aws_route" "nat_c" {
  route_table_id         = var.route_table_c_id
  destination_cidr_block = "0.0.0.0/0"

  network_interface_id = aws_instance.nat["C"].primary_network_interface_id
}
