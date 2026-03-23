variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução"
}

variable "schedule_expression" {
  type        = string
  description = "Expressão cron/rate para agendamento (ex: rate(1 day))"
}

variable "lambda_arn" {
  type        = string
  description = "ARN da função Lambda a ser invocada"
}

variable "lambda_name" {
  type        = string
  description = "Nome da função Lambda"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
