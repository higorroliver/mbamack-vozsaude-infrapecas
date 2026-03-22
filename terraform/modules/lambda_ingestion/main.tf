###############################################################################
# Módulo: Lambda de Ingestão — função base para coleta de dados
###############################################################################

data "archive_file" "ingestion" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/ingestion"
  output_path = "${path.module}/../../lambda/ingestion.zip"
}

resource "aws_lambda_function" "ingestion" {
  function_name    = "${var.project_name}-${var.environment}-ingestion"
  description      = "Lambda de ingestão de dados — Vozes da Saúde"
  role             = var.lambda_role_arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  timeout          = var.lambda_timeout
  memory_size      = var.memory_size
  filename         = data.archive_file.ingestion.output_path
  source_code_hash = data.archive_file.ingestion.output_base64sha256

  environment {
    variables = {
      DATALAKE_BUCKET = var.datalake_bucket
      ENVIRONMENT     = var.environment
      PROJECT_NAME    = var.project_name
    }
  }

  tags = var.tags
}
