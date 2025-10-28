# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "imanage-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
}

# Enable versioning for state file protection
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the state bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Get current AWS account ID for unique bucket naming
data "aws_caller_identity" "current" {}

# Output the bucket name for reference
output "terraform_state_bucket" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}
