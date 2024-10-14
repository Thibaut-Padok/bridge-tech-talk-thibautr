#-- Backend to store TF states -----------------------------------------------
terraform {
  backend "s3" {
    bucket = "bridge-tech-talk-demo"
    key    = "network"
    region = "eu-west-3"
  }
}
