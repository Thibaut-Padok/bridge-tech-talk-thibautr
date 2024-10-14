module "vpc" {
  source = "../../modules/network"
  context = {
    project = "btt-demo"
    env     = "production"

    region                = "eu-west-3"
    vpc_name              = "btt"
    vpc_cidr              = "10.0.0.0/16"
    vpc_availability_zone = ["eu-west-3a", "eu-west-3b"]

    public_subnet_suffix  = "public"
    private_subnet_suffix = "private"

    enable_nat_gateway     = false
    one_nat_gateway_per_az = false

    create_igw = true

    map_public_ip_on_launch = false

    public_dedicated_network_acl  = false
    private_dedicated_network_acl = false
    intra_dedicated_network_acl   = false

    vpc_flow_log_enabled = false

    public_subnets_cidr = [
      "10.0.0.0/28",
      "10.0.0.16/28"
    ]

    private_subnets_cidr = [
      "10.0.16.0/21",
      "10.0.32.0/21"
    ]

    enable_nat_gateway = true
    single_nat_gateway = true
  }
}
