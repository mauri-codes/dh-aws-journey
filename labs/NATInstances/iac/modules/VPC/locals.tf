locals {
  default_subnet_definition = {
    "${var.subnet_prefix}web-A" = {
      cidr_block = "10.16.0.0/20"
      az         = "us-east-1a"
    }
    "${var.subnet_prefix}web-B" = {
      cidr_block = "10.16.16.0/20"
      az         = "us-east-1b"
    }
    "${var.subnet_prefix}web-C" = {
      cidr_block = "10.16.32.0/20"
      az         = "us-east-1c"
    }
    "${var.subnet_prefix}app-A" = {
      cidr_block = "10.16.64.0/20"
      az         = "us-east-1a"
    }
    "${var.subnet_prefix}app-B" = {
      cidr_block = "10.16.80.0/20"
      az         = "us-east-1b"
    }
    "${var.subnet_prefix}app-C" = {
      cidr_block = "10.16.96.0/20"
      az         = "us-east-1c"
    }
  }
  subnet_definition = var.subnet_definition != null ? var.subnet_definition : local.default_subnet_definition
}