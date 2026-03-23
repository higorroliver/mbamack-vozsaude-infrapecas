###############################################################################
# Módulo: Glue Catalog — database e tabelas para catalogação
###############################################################################

resource "aws_glue_catalog_database" "datalake" {
  name        = var.database_name
  description = "Database do data lake Vozes da Saúde — catálogo de dados de avaliações de UBS"

  tags = var.tags
}

# Crawler opcional para descoberta automática de schema
resource "aws_glue_crawler" "bronze" {
  database_name = aws_glue_catalog_database.datalake.name
  name          = "${var.database_name}_bronze_crawler"
  role          = var.glue_role_arn
  description   = "Crawler para camada bronze do data lake"

  s3_target {
    path = "s3://${var.datalake_bucket}/bronze/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "LOG"
  }

  tags = var.tags
}

resource "aws_glue_crawler" "silver" {
  database_name = aws_glue_catalog_database.datalake.name
  name          = "${var.database_name}_silver_crawler"
  role          = var.glue_role_arn
  description   = "Crawler para camada silver do data lake"

  s3_target {
    path = "s3://${var.datalake_bucket}/silver/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "LOG"
  }

  tags = var.tags
}

resource "aws_glue_crawler" "gold" {
  database_name = aws_glue_catalog_database.datalake.name
  name          = "${var.database_name}_gold_crawler"
  role          = var.glue_role_arn
  description   = "Crawler para camada gold do data lake"

  s3_target {
    path = "s3://${var.datalake_bucket}/gold/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "LOG"
  }

  tags = var.tags
}
