#-- Backend to store TF states -----------------------------------------------
terraform {
  backend "s3" {
    bucket = "bridge-tech-talk-demo"
    key    = "ecs-cluster"
    region = "eu-west-3"
  }
}
