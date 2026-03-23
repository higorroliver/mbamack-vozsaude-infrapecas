variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução"
}

variable "datalake_bucket_arn" {
  type        = string
  description = "ARN do bucket S3 do data lake"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
