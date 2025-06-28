variable "vpc_id" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "instance_sg_name" {
  type = string
}
variable "alb_sg_name" {
  type = string
}
variable "bucket_name" {
  type = string
}
variable "instance_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "instance_ami" {
  type = string
}
variable "is_solution" {
  type = bool
}
variable "key_pair" {
  type = string
}
