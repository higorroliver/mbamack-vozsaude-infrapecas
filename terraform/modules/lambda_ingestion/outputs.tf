output "function_name" {
  description = "Nome da função Lambda de ingestão"
  value       = aws_lambda_function.ingestion.function_name
}

output "function_arn" {
  description = "ARN da função Lambda de ingestão"
  value       = aws_lambda_function.ingestion.arn
}

output "invoke_arn" {
  description = "Invoke ARN da função Lambda"
  value       = aws_lambda_function.ingestion.invoke_arn
}
