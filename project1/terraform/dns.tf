resource "aws_route53_zone" "my-aws-project" {
  name = "my-aws-project.com."
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my-aws-project.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my-distribution.hosted_zone_id
    evaluate_target_health = false
  }


}

