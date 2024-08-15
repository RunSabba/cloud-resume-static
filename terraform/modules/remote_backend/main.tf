# IAM Terraform USer
resource "aws_iam_user" "tf_user" {
  name = var.iam_username
}

# Attach AdminAccess policy to the IAM user
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.tf_user.id
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = var.state_bucket

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.state_bucket
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = aws_s3_bucket.tf-state-bucket.arn,
        Principal = {
          AWS = aws_iam_user.tf_user.arn
        }
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = "${aws_s3_bucket.tf-state-bucket.arn}/*",
        Principal = {
          AWS = aws_iam_user.tf_user.arn
        }
      }
    ]
  })
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "state-lock-table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.table_name
  }
}