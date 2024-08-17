#creating my static site bucket
resource "aws_s3_bucket" "static_web_bucket" {
  bucket        = var.static_bucket
  force_destroy = var.force_destroy

  tags = {
    Name = "Static Website Bucket-${var.static_bucket}"
  }
}
#enabling versioning to protect files from deletion
resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.static_web_bucket.id

  versioning_configuration {
    status = var.versioning_status
  }
}
#configuring the bucket as a static site.
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.static_web_bucket.id

  index_document {
    suffix = "index.html"
  }
}
#configuring my bucket here to be public
resource "aws_s3_bucket_public_access_block" "static_bucket_allow_public_access" {
  bucket = aws_s3_bucket.static_web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
#creating my bucket policy for read access
resource "aws_s3_bucket_policy" "static_web_bucket_policy" {
  bucket = aws_s3_bucket.static_web_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"],
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.static_web_bucket.arn}/*"], #this (/*) will grant access to the objects withiun the bucket
        Principal = "*"                                           # allows anyone access to get objects from bucket
      },
    ]
  })
  #terraform will configure the public access before applying the polciy to the bucket. if not we will get access errors.
  depends_on = [aws_s3_bucket_public_access_block.static_bucket_allow_public_access]
}