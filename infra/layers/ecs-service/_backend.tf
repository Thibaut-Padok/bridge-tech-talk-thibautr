#-- Backend to store TF states -----------------------------------------------
terraform {
  backend "s3" {
    bucket = "bridge-tech-talk-demo"
    key    = "ecs-service"
    region = "eu-west-3"
  }
}
