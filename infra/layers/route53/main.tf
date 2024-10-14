data "aws_route53_zone" "lab" {
  name         = "lab.aws.padok.cloud"
  private_zone = false
}

# Create a new hosted zone for "thibautr.lab.aws.padok.cloud"
resource "aws_route53_zone" "thibautr" {
  name = "thibautr.lab.aws.padok.cloud"
}

# Create delegation records in the parent zone "lab.aws.padok.cloud"
resource "aws_route53_record" "delegate" {
  zone_id = data.aws_route53_zone.lab.zone_id
  name    = "thibautr.${data.aws_route53_zone.lab.name}"
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.thibautr.name_servers
}

# Create a "www.thibautr.lab.aws.padok.cloud" record in the new hosted zone
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.thibautr.zone_id
  name    = "www.thibautr.lab.aws.padok.cloud"
  type    = "CNAME"
  ttl     = 300
  records = [""] # HARCODED
}
