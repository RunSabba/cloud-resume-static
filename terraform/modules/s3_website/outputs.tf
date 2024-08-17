output "static_bucket_id" {
  value = aws_s3_bucket.static_web_bucket.id
}

output "static_bucket_arn" {
  value = aws_s3_bucket.static_web_bucket.arn
}

output "static_bucket_url" {
  value = "http://${aws_s3_bucket.static_web_bucket.bucket}.s3-website-${var.region}.amazonaws.com"
}