

resource "aws_s3_bucket" "www-my-aws-project-com" {
  bucket = "www.my-aws-project.com"

}


resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "my-config" {
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  index_document {
    suffix = "index.html"
  }
}

locals {
    mime_types = {
      ".html" = "text/html"
      ".png"  = "image/png"
      ".jpg"  = "image/jpeg"
      ".gif"  = "image/gif"
      ".css"  = "text/css"
      ".js"   = "application/javascript"
    }
}

resource "aws_s3_object" "build" {
  for_each = fileset("../webapp/build/", "**")
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  key = each.value
  source = "../webapp/build/${each.value}"
  etag = filemd5("../webapp/build/${each.value}")
  acl    = "public-read"
content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}


