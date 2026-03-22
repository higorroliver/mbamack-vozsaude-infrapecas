variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente de execução"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
}
