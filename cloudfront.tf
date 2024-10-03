# CloudFront distribution using the ALB as the origin
resource "aws_cloudfront_distribution" "webpage_cf" {
  origin {
    domain_name = aws_lb.webpage-lb.dns_name
    origin_id   = "ALB-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Allows both HTTP and HTTPS access
    viewer_protocol_policy = "allow-all" 
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  #Allow all edge locations
  price_class = "PriceClass_All"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}