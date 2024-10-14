resource "aws_s3_bucket" "bootstrap" {
  bucket = "bridge-tech-talk-demo"

  tags = {
    Name        = "bridge-tech-talk-demo"
    Environment = "prod"
  }
}
