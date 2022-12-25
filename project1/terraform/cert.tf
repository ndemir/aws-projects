resource "aws_acm_certificate" "cert-my-aws-project-com" {
  domain_name       = "my-aws-project.com"
  validation_method = "DNS"
    subject_alternative_names = ["www.my-aws-project.com", "my-aws-project.com"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.cert-my-aws-project-com.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-validation-record : record.fqdn]
}


resource "aws_route53_record" "cert-validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.cert-my-aws-project-com.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.my-aws-project.zone_id
}
