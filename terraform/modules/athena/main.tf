###############################################################################
# Módulo: Athena — workgroup para consultas analíticas
###############################################################################

resource "aws_athena_workgroup" "main" {
  name        = "${var.project_name}-${var.environment}"
  description = "Workgroup Athena para consultas analíticas — Vozes da Saúde"
  state       = "ENABLED"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${var.datalake_bucket}/${var.athena_results_prefix}/"
    }
  }

  tags = var.tags
}
