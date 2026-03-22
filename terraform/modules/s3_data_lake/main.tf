###############################################################################
# Módulo: S3 Data Lake — modelo medallion
###############################################################################

resource "aws_s3_bucket" "datalake" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Versionamento habilitado para rastreabilidade
resource "aws_s3_bucket_versioning" "datalake" {
  bucket = aws_s3_bucket.datalake.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bloqueio de acesso público
resource "aws_s3_bucket_public_access_block" "datalake" {
  bucket = aws_s3_bucket.datalake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Criptografia padrão (SSE-S3 — sem custo adicional)
resource "aws_s3_bucket_server_side_encryption_configuration" "datalake" {
  bucket = aws_s3_bucket.datalake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Objetos placeholder para criar a estrutura de pastas do data lake
resource "aws_s3_object" "datalake_prefixes" {
  for_each = toset(var.datalake_prefixes)

  bucket  = aws_s3_bucket.datalake.id
  key     = "${each.value}.gitkeep"
  content = ""
  tags    = var.tags
}

# Pasta para resultados do Athena
resource "aws_s3_object" "athena_results" {
  bucket  = aws_s3_bucket.datalake.id
  key     = "${var.athena_results_prefix}/.gitkeep"
  content = ""
  tags    = var.tags
}
