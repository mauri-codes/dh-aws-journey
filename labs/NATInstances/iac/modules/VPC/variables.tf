variable "vpc_cidr_block" {
  type    = string
  default = "10.16.0.0/16"
}
variable "subnet_prefix" {
  type = string
}
variable "suffix" {
  type = string
}
variable "subnet_definition" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = null
}
variable "public_ig_route" {
  type    = bool
  default = true
}
variable "vpc_name" {
  type = string
}
variable "ig_name" {
  type = string
}
variable "public_rt_name" {
  type = string
}
variable "private_rt_name" {
  type = string
}
variable "is_solution" {
  type = bool
}
