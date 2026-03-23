###############################################################################
# Outputs globais do projeto
###############################################################################

output "project_name" {
  description = "Nome do projeto"
  value       = var.project_name
}

output "environment" {
  description = "Ambiente de execução"
  value       = var.environment
}

# ─── S3 Data Lake ────────────────────────────────────────────────────────────
output "datalake_bucket_name" {
  description = "Nome do bucket S3 do data lake"
  value       = module.s3_data_lake.bucket_name
}

output "datalake_bucket_arn" {
  description = "ARN do bucket S3 do data lake"
  value       = module.s3_data_lake.bucket_arn
}

# ─── IAM ─────────────────────────────────────────────────────────────────────
output "lambda_role_arn" {
  description = "ARN da role IAM da Lambda de ingestão"
  value       = module.iam.lambda_role_arn
}

output "glue_role_arn" {
  description = "ARN da role IAM do Glue"
  value       = module.iam.glue_role_arn
}

# ─── Lambda ──────────────────────────────────────────────────────────────────
output "lambda_function_name" {
  description = "Nome da função Lambda de ingestão"
  value       = module.lambda_ingestion.function_name
}

output "lambda_function_arn" {
  description = "ARN da função Lambda de ingestão"
  value       = module.lambda_ingestion.function_arn
}

# ─── EventBridge ─────────────────────────────────────────────────────────────
output "eventbridge_rule_arn" {
  description = "ARN da regra EventBridge de agendamento"
  value       = module.eventbridge.rule_arn
}

# ─── Glue ────────────────────────────────────────────────────────────────────
output "glue_database_name" {
  description = "Nome do database no Glue Catalog"
  value       = module.glue_catalog.database_name
}

# ─── Athena ──────────────────────────────────────────────────────────────────
output "athena_workgroup_name" {
  description = "Nome do workgroup Athena"
  value       = module.athena.workgroup_name
}

# ─── CloudWatch ──────────────────────────────────────────────────────────────
output "lambda_log_group_name" {
  description = "Nome do log group CloudWatch da Lambda"
  value       = module.cloudwatch.lambda_log_group_name
}
