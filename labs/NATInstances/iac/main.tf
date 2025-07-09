module "instance_role" {
  source    = "./modules/InstanceRole"
  role_name = "${local.labName}_SSMRole"
}

module "vpc" {
  source          = "./modules/VPC"
  ig_name         = "${local.labName}_IG"
  public_rt_name  = "${local.labName}-public_rt"
  private_rt_name = "${local.labName}-private_rt"
  vpc_name        = "${local.labName}-vpc"
  suffix          = var.suffix
  subnet_prefix   = "${local.labName}-"
  vpc_cidr_block  = local.vpc_cidr
  is_solution     = local.is_solution
}

module "app" {
  source           = "./modules/App"
  vpc_id           = module.vpc.vpc_id
  instance_sg_name = "${local.labName}_InstanceSG_${var.suffix}"
  alb_sg_name   = "${local.labName}_ALB_SG_${var.suffix}"
  instance_type = local.instance_type
  instance_name = "${local.labName}App${var.suffix}"
  key_pair      = var.KeyPair
  instance_ami  = local.al2023
  public_subnets = [
    module.vpc.subnet_ids["${local.labName}-web-A"],
    module.vpc.subnet_ids["${local.labName}-web-B"],
    module.vpc.subnet_ids["${local.labName}-web-C"]
  ]
  private_subnets = [
    module.vpc.subnet_ids["${local.labName}-app-A"],
    module.vpc.subnet_ids["${local.labName}-app-B"],
    module.vpc.subnet_ids["${local.labName}-app-C"]
  ]
  is_solution = local.is_solution
}

module "nat" {
  source           = "./modules/NATInstances"
  count            = local.is_solution ? 1 : 0
  vpc_id           = module.vpc.vpc_id
  subnet_A         = module.vpc.subnet_ids["${local.labName}-web-A"]
  subnet_B         = module.vpc.subnet_ids["${local.labName}-web-B"]
  subnet_C         = module.vpc.subnet_ids["${local.labName}-web-C"]
  instance_ami     = local.al2023
  key_pair         = var.KeyPair
  instance_type    = local.instance_type
  private_cidr     = local.vpc_cidr
  role_name        = module.instance_role.role_name
  nat_sg_name      = "${local.labName}_NAT_SG_${var.suffix}"
  route_table_a_id = module.vpc.route_table_a_id
  route_table_b_id = module.vpc.route_table_b_id
  route_table_c_id = module.vpc.route_table_c_id
  instance_sg_id   = module.app.instance_sg_id
}
