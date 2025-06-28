locals {
  labName       = var.LabName
  al2023        = data.aws_ssm_parameter.al2023.value
  instance_type = "t2.micro"
  vpc_cidr      = "10.16.0.0/16"
  steps = {
    "BASE"     = 0
    "COMPLETE" = 1
  }
  step             = local.steps[var.step]
  is_solution      = local.step == 1
  app_package_path = "${path.module}/AppInstance"
}
