variable "database_name" {
  type        = string
  description = "Nome do database no Glue Catalog"
}

variable "datalake_bucket" {
  type        = string
  description = "Nome do bucket S3 do data lake"
}

variable "glue_role_arn" {
  type        = string
  description = "ARN da role IAM do Glue"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
