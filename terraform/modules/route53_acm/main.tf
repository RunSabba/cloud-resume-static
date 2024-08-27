data "aws_route53_zone" "dns_zone" { #querying aws for the zone id of the runsabba.com domain
  name         = var.static_domain
  private_zone = false #ensures we want to look for a public zone
}

resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.static_domain
  subject_alternative_names = ["*.${var.static_domain}"] #any subdomains we want to attach to the cert. only runsabba.com for now
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true #terraform will create a new cert before destroying old
  }
}

resource "aws_route53_record" "domain_validation" { #cert validation infomation provided by acm
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name #DNS Name verification
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value] #DNS record value verification
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type #record type, CNAME verification
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
  ttl             = var.dns_ttl
}

resource "aws_acm_certificate_validation" "ssl_validation" { # this block will check the info in the resource above to complete validation
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.domain_validation.fqdn] #fully qualified domain name
}