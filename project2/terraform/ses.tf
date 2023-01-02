resource "aws_route53_zone" "my_aws_project_com_zone" {
  name = "my-aws-project.com."
}
resource "aws_ses_domain_identity" "ses_domain_identity" {
  domain = "my-aws-project.com"
}

resource "aws_route53_record" "ses_verification_record" {
  zone_id = aws_route53_zone.my_aws_project_com_zone.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain_identity.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain_identity.verification_token]
}

resource "aws_ses_domain_identity_verification" "ses_domain_identity_verification" {
  domain = aws_ses_domain_identity.ses_domain_identity.id

  depends_on = [aws_route53_record.ses_verification_record]
}