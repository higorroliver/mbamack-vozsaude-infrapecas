output "database_name" {
  description = "Nome do database no Glue Catalog"
  value       = aws_glue_catalog_database.datalake.name
}

output "bronze_crawler_name" {
  description = "Nome do crawler da camada bronze"
  value       = aws_glue_crawler.bronze.name
}

output "silver_crawler_name" {
  description = "Nome do crawler da camada silver"
  value       = aws_glue_crawler.silver.name
}

output "gold_crawler_name" {
  description = "Nome do crawler da camada gold"
  value       = aws_glue_crawler.gold.name
}
