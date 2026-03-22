variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução"
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN da role IAM para a Lambda"
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout da Lambda em segundos"
  default     = 300
}

variable "memory_size" {
  type        = number
  description = "Memória alocada para a Lambda em MB"
  default     = 256
}

variable "datalake_bucket" {
  type        = string
  description = "Nome do bucket S3 do data lake"
}

variable "log_group_arn" {
  type        = string
  description = "ARN do log group CloudWatch da Lambda"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
