locals {
  name_prefix = var.project_name
}

# Exemplo: bucket do datalake (bronze/silver)
resource "aws_s3_bucket" "datalake" {
  bucket = "${local.name_prefix}-datalake"
  tags   = var.tags
}

output "datalake_bucket_name" {
  value = aws_s3_bucket.datalake.bucket
}