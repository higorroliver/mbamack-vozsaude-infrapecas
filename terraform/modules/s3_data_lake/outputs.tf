output "bucket_name" {
  description = "Nome do bucket S3 do data lake"
  value       = aws_s3_bucket.datalake.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3 do data lake"
  value       = aws_s3_bucket.datalake.arn
}

output "bucket_id" {
  description = "ID do bucket S3 do data lake"
  value       = aws_s3_bucket.datalake.id
}
