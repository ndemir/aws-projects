resource "aws_cloudfront_distribution" "my-distribution" {
  origin {
    domain_name              = aws_s3_bucket.www-my-aws-project-com.bucket_regional_domain_name
    origin_id   = "S3-Origin"
  }


  aliases = ["www.my-aws-project.com"]

  enabled = true
    default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    viewer_protocol_policy = "redirect-to-https"

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }


  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert-my-aws-project-com.arn
    ssl_support_method = "sni-only"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [
    aws_acm_certificate.cert-my-aws-project-com,
  ]
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.my-distribution.domain_name
}