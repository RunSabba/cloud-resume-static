output "im_user_name" {
  description = "IAM TF Username"
  value = module.backend.tf_user_arn
}

output "static_bucket_id" {
  value = module.s3_website.static_bucket_id
}

output "static_bucket_arn" {
  value = module.s3_website.static_bucket_arn
}

output "static_bucket_url" {
  value = module.s3_website.static_bucket_url
}

output "aws_cloudfront_distribution_ID" {
  value = module.cloudfront_dist.aws_cloudfront_distribution_id  
}