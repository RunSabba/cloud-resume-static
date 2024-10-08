# This will create the OAC policy so that only cloudfront has direct access to the static content. 
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
    name                              = "OAC for s3 bucket"
    description                       = " OAC for static website bucket "
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always" #sign every request for security
    signing_protocol                  = "sigv4"  #standard signature process for aws services
}

resource "aws_cloudfront_distribution" "static_website_distribution" {
    enabled = true # enables CF distro
    is_ipv6_enabled = true
    default_root_object = "index.html"
    aliases = [var.static_domain] # you must use [] list format for aliases in terraform. aliases expect a list.
    
    origin {
        domain_name = var.bucket_regional_domain_name
        origin_id = "S3-${var.static_bucket_id}"
        origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id # i needed to upgrade aws proivder to 4.40 from ~> 3.0 to use this 
    }

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"] #http methods allowed to be cached
        cached_methods = ["GET", "HEAD"] #http methods that are actualy cahced
        # Using AWS Managed-Caching Optimized cache policy
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        target_origin_id = "S3-${var.static_bucket_id}"
        viewer_protocol_policy = "redirect-to-https" #redirects http traffic to https for security
    } 

    restrictions {
        geo_restriction {
            restriction_type = "none" # no geographic restrictions. i can add blacklists to block certian countries
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.ssl_certificate_arn
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
}

resource "aws_s3_bucket_policy" "cloudfront_oac_policy" {
  bucket = var.static_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.static_bucket_id}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static_website_distribution.arn #only the cf distro has direct access to the bucket.
          }
        }
      }
    ]
  })
}

resource "aws_route53_record" "static_website_alias_record" {
    zone_id = var.aws_route53_zoneID
    name    = var.static_domain
    type    = "A" #domain ----> ipv4 

    alias { #Below we're setting the alias. runsabba.com --> CF Distro --> s3 bucket
        name                   = aws_cloudfront_distribution.static_website_distribution.domain_name
        zone_id                = aws_cloudfront_distribution.static_website_distribution.hosted_zone_id
        evaluate_target_health =  true
    }
}