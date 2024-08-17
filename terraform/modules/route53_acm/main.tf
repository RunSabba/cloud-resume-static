data "aws_route53_zone" "dns_zone" {
  name         = var.static_domain
  private_zone = false
}

resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.static_domain
  subject_alternative_names = ["*.${var.static_domain}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
  ttl             = var.dns_ttl
}

resource "aws_acm_certificate_validation" "ssl_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_validation.fqdn]
}