###############################################################################
# Módulo: CloudWatch — log groups para Lambda e jobs
###############################################################################

resource "aws_cloudwatch_log_group" "lambda_ingestion" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-ingestion"
  retention_in_days = 14
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "glue_jobs" {
  name              = "/aws-glue/${var.project_name}-${var.environment}"
  retention_in_days = 14
  tags              = var.tags
}
