output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for name, subnet in aws_subnet.subnets :
    name => subnet.id
  }
}
output "route_table_a_id" {
  value = aws_route_table.private_rt_a.id
}
output "route_table_b_id" {
  value = aws_route_table.private_rt_b.id
}
output "route_table_c_id" {
  value = aws_route_table.private_rt_c.id
}
