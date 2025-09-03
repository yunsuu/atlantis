resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.bucket_name}-${var.environment}-${random_id.bucket_suffix.hex}"
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.bucket_name}-${var.environment}"
      Environment = var.environment
      ManagedBy   = "Atlantis"
      CreatedDate = "2025-01-03"
    }
  )
}

resource "aws_s3_bucket_versioning" "test_bucket_versioning" {
  bucket = aws_s3_bucket.test_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "test_bucket_pab" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}