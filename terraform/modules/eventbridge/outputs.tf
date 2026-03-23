output "rule_arn" {
  description = "ARN da regra EventBridge"
  value       = aws_cloudwatch_event_rule.ingestion_schedule.arn
}

output "rule_name" {
  description = "Nome da regra EventBridge"
  value       = aws_cloudwatch_event_rule.ingestion_schedule.name
}
