output "static_bucket_id" {
  value = aws_s3_bucket.static_web_bucket.id
}

output "static_bucket_arn" {
  value = aws_s3_bucket.static_web_bucket.arn
}

output "static_bucket_url" {
  value = "http://${aws_s3_bucket.static_web_bucket.bucket}.s3-website-${var.region}.amazonaws.com"
}

output "bucket_regional_domain_name" {
  description = "The regional name of the bucket"
  value = aws_s3_bucket.static_web_bucket.bucket_regional_domain_name
  
}