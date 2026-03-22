output "lambda_log_group_name" {
  description = "Nome do log group da Lambda de ingestão"
  value       = aws_cloudwatch_log_group.lambda_ingestion.name
}

output "lambda_log_group_arn" {
  description = "ARN do log group da Lambda de ingestão"
  value       = aws_cloudwatch_log_group.lambda_ingestion.arn
}

output "glue_log_group_name" {
  description = "Nome do log group do Glue"
  value       = aws_cloudwatch_log_group.glue_jobs.name
}
