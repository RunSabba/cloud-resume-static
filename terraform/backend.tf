terraform {
  backend "s3" {
    bucket         = "tf-state-bucket-runsabba"
    key            = "static-site/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock-db"
    encrypt        = true
  }
}  