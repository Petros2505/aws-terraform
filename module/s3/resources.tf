resource "aws_s3_bucket" "s3" {
  bucket = var.s3_bucket

  tags = merge(var.tags, {
    Name = var.s3_bucket
  })
}



resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
