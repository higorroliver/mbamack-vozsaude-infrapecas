###############################################################################
# Locals — padronização de nomes e tags
###############################################################################

locals {
  # Prefixo padrão para nomes de recursos
  name_prefix = "${var.project_name}-${var.environment}"

  # Tags padrão aplicadas a todos os recursos
  default_tags = merge(
    {
      project     = var.project_name
      environment = var.environment
      managed_by  = "terraform"
      repository  = "mbamack-vozsaude-infrapecas"
      owner       = var.owner
    },
    var.tags
  )

  # Prefixos das camadas do data lake (modelo medallion)
  datalake_prefixes = [
    "raw/",
    "bronze/",
    "silver/",
    "gold/",
    "artifacts/",
    "logs/",
  ]

  # Nome do bucket do data lake
  bucket_name = var.bucket_name

  # Glue database
  glue_database_name = replace(var.project_name, "-", "_")
}
