variable "aws_region" {
  type        = string
  description = "Região AWS do projeto"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (prefixo para recursos)"
  default     = "vozsaude"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
  default = {
    Project = "vozsaude"
    Owner   = "mba"
  }
}