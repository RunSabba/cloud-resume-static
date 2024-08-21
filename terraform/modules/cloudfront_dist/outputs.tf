output "aws_cloudfront_distribution_id" {
    description = "the ID of the CF distribution"
    value = aws_cloudfront_distribution.static_website_distribution.id
}