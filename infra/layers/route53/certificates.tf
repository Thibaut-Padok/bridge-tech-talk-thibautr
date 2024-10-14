# Request an ACM certificate for www.thibautr.lab.aws.padok.cloud
resource "aws_acm_certificate" "www" {
  domain_name       = "www.thibautr.lab.aws.padok.cloud"
  validation_method = "DNS"

  # Wait for the validation records to be created
  lifecycle {
    create_before_destroy = true
  }
}

# Create the DNS validation records in the new hosted zone
# resource "aws_route53_record" "www_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.www.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       type    = dvo.resource_record_type
#       value   = dvo.resource_record_value
#       zone_id = aws_route53_zone.thibautr.zone_id
#     }
#   }

#   zone_id = each.value.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   ttl     = 300
#   records = [each.value.value]
# }

# Validate the ACM certificate with Route 53 DNS validation
# resource "aws_acm_certificate_validation" "www_validation" {
#   certificate_arn         = aws_acm_certificate.www.arn
#   validation_record_fqdns = [for record in aws_route53_record.www_validation : record.fqdn]
# }
