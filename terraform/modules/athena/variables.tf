variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução"
}

variable "datalake_bucket" {
  type        = string
  description = "Nome do bucket S3 do data lake"
}

variable "athena_results_prefix" {
  type        = string
  description = "Prefixo no S3 para resultados de queries Athena"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
