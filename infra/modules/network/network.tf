module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  create_vpc = true

  ## VPC
  name = var.context.vpc_name
  cidr = var.context.vpc_cidr

  ## Subnets CIDR
  azs             = var.context.vpc_availability_zone
  private_subnets = var.context.private_subnets_cidr
  public_subnets  = var.context.public_subnets_cidr
  intra_subnets   = var.context.intra_subnets_cidr

  ## Subnet suffix
  public_subnet_suffix  = var.context.public_subnet_suffix
  private_subnet_suffix = var.context.private_subnet_suffix
  intra_subnet_suffix   = var.context.intra_subnet_suffix

  ## Gateway
  enable_nat_gateway     = var.context.enable_nat_gateway
  single_nat_gateway     = var.context.single_nat_gateway
  one_nat_gateway_per_az = var.context.one_nat_gateway_per_az
  create_igw             = var.context.create_igw
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  ## Disable AWS default resources
  manage_default_route_table    = false
  manage_default_vpc            = false
  manage_default_network_acl    = false
  manage_default_security_group = false

  ## Enable Public IP and NACLs - disable by default
  map_public_ip_on_launch       = var.context.map_public_ip_on_launch
  public_dedicated_network_acl  = var.context.public_dedicated_network_acl
  private_dedicated_network_acl = var.context.private_dedicated_network_acl
  intra_dedicated_network_acl   = var.context.intra_dedicated_network_acl

  ## Define NACLs
  # Used only if public_dedicated_network_acl is true
  public_inbound_acl_rules  = var.context.public_inbound_acl_rules
  public_outbound_acl_rules = var.context.public_outbound_acl_rules

  # Used only if private_dedicated_network_acl is true
  private_inbound_acl_rules  = var.context.private_inbound_acl_rules
  private_outbound_acl_rules = var.context.private_outbound_acl_rules

  # used only if intra_dedicated_network_acl is true
  intra_inbound_acl_rules  = var.context.intra_inbound_acl_rules
  intra_outbound_acl_rules = var.context.intra_outbound_acl_rules

  ## Tagging
  tags = var.context.tags

  vpc_tags = var.context.vpc_tags

  public_subnet_tags = merge(
    {
      "Public" = "True"
    },
    var.context.public_subnet_tags,
  )

  private_subnet_tags = merge(
    {
      "Private" = "True"
    },
    var.context.private_subnet_tags,
  )

  intra_subnet_tags = merge(
    {
      "Intra" = "True"
    },
    var.context.intra_subnet_tags,
  )

  private_acl_tags = var.context.private_acl_tags
  public_acl_tags  = var.context.public_acl_tags
  intra_acl_tags   = var.context.intra_acl_tags
}
