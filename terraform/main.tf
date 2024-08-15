terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
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

output "im_user_name" {
  value = module.backend.tf_user_arn

}