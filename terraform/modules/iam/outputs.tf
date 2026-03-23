output "lambda_role_arn" {
  description = "ARN da role IAM da Lambda"
  value       = aws_iam_role.lambda.arn
}

output "lambda_role_name" {
  description = "Nome da role IAM da Lambda"
  value       = aws_iam_role.lambda.name
}

output "glue_role_arn" {
  description = "ARN da role IAM do Glue"
  value       = aws_iam_role.glue.arn
}

output "glue_role_name" {
  description = "Nome da role IAM do Glue"
  value       = aws_iam_role.glue.name
}
