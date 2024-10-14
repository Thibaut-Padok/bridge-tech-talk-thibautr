# SSM Bastion to connect to EKS trough an SSH tunnel
module "ssm_bastion" {
  source = "../../modules/bastion-ssm/"

  vpc_zone_identifier = module.vpc.private_subnets

  context = var.context
}
