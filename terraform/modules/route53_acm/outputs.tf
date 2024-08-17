output "ssl_certificate_arn" {
    value = aws_acm_certificate.ssl_certificate.arn  
}

output "aws_route53_zoneID" {
    value = data.aws_route53_zone.dns_zone.zone_id  
}