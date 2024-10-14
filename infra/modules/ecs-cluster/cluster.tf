module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v4.0.1"

  cluster_name = var.ecs_cluster_name


  cluster_settings = {
    "name" : "containerInsights",
    "value" : "enabled"
  }

  #capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}
