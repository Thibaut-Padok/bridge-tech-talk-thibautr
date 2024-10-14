module "ecs_cluster" {
  source           = "../../modules/ecs-cluster"
  ecs_cluster_name = "btt-production-cluster"

  vpc_id           = "vpc-..."                    # HARCODED
  public_subnet_id = ["subnet-...", "subnet-..."] # HARCODED
}
