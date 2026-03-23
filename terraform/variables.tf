###############################################################################
# Variáveis globais do projeto Vozes da Saúde
###############################################################################

variable "aws_region" {
  type        = string
  description = "Região AWS onde os recursos serão provisionados"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (usado como prefixo em todos os recursos)"
  default     = "vozes-da-saude"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução (lab, dev, prod)"
  default     = "lab"
}

variable "owner" {
  type        = string
  description = "Responsável pelo projeto"
  default     = "mba-mackenzie"
}

variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3 do data lake (deve ser globalmente único)"
  default     = "vozes-da-saude-datalake"
}

variable "lambda_schedule_expression" {
  type        = string
  description = "Expressão cron/rate do EventBridge para agendamento da Lambda de ingestão"
  default     = "rate(1 day)"
}

variable "athena_results_prefix" {
  type        = string
  description = "Prefixo no S3 para armazenar resultados de queries Athena"
  default     = "athena-results"
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout da função Lambda de ingestão (segundos)"
  default     = 300
}

variable "lambda_memory_size" {
  type        = number
  description = "Memória alocada para a função Lambda de ingestão (MB)"
  default     = 256
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais para aplicar em todos os recursos"
  default     = {}
}
