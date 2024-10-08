terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40"
    }
  }
}

provider "aws" {
  region = var.region
}

module "backend" {
  source       = "./modules/remote_backend"
  iam_username = var.iam_username
  state_bucket = var.state_bucket
  table_name   = var.table_name
}

output "DynamoDB_table_arn" {
  value = module.backend.DynamoDB_table_arn
}

module "route53_acm" {
  source = "./modules/route53_acm"
  static_domain = var.static_domain
  dns_ttl = var.dns_ttl
}

module "s3_website" {
  source = "./modules/s3_website"
  static_bucket = var.static_bucket
  force_destroy = var.force_destroy
  versioning_status = var.versioning_status
  region = var.region
}

module "cloudfront_dist" {
  source = "./modules/cloudfront_dist"
  static_domain = var.static_domain
  bucket_regional_domain_name = module.s3_website.bucket_regional_domain_name
  static_bucket_id = module.s3_website.static_bucket_id
  ssl_certificate_arn = module.route53_acm.ssl_certificate_arn
  aws_route53_zoneID = module.route53_acm.aws_route53_zoneID
}
