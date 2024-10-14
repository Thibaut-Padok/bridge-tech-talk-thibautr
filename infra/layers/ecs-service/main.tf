module "app" {
  source = "../../modules/ecs-service"

  region = "eu-west-3"


  cluster = {
    id   = "arn:aws:ecs:..." # HARCODED
    name = "btt-production-cluster"
  }

  vpc_id              = "vpc-..."                    # HARCODED
  private_subnets_ids = ["subnet-...", "subnet-..."] # HARCODED
  bastion_sg          = "sg-..."                     # HARCODED

  lb = {
    enabled           = true
    lb_arn            = "arn:aws:elasticloadbalancing:xxxx:loadbalancer/..." # HARCODED
    target_group_arn  = "arn:aws:elasticloadbalancing:exxxx:targetgroup/..." # HARCODED
    security_group_id = "sg-..."                                             # HARCODED
  }

  config = {
    name = "btt-app"
    containers = {
      "main" = {
        name    = "node-app"
        image   = "thibautpadok/node-app:btt"
        port    = 3000
        secrets = {}
      }
    }
    cpu           = 256
    memory        = 512
    desired_count = 1
  }

  debug_policy_arn     = "arn:aws:iam::...:policy/btt-ecs-task-debug-and-decrypt-..." # HARCODED
  remote_debug_enabled = true
}
