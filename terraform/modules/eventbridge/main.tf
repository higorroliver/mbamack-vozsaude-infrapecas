###############################################################################
# Módulo: EventBridge — agendamento de execução da Lambda
###############################################################################

resource "aws_cloudwatch_event_rule" "ingestion_schedule" {
  name                = "${var.project_name}-${var.environment}-ingestion-schedule"
  description         = "Agendamento periódico da Lambda de ingestão — Vozes da Saúde"
  schedule_expression = var.schedule_expression
  state               = "ENABLED"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule = aws_cloudwatch_event_rule.ingestion_schedule.name
  arn  = var.lambda_arn

  input = jsonencode({
    source      = "eventbridge-schedule"
    detail_type = "scheduled-ingestion"
  })
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ingestion_schedule.arn
}
