variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3 do data lake"
}

variable "datalake_prefixes" {
  type        = list(string)
  description = "Lista de prefixos (pastas) do data lake"
}

variable "athena_results_prefix" {
  type        = string
  description = "Prefixo para resultados do Athena"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
