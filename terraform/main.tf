###############################################################################
# Orquestração dos módulos — Vozes da Saúde
###############################################################################

# ─── Data Lake S3 ────────────────────────────────────────────────────────────
module "s3_data_lake" {
  source = "./modules/s3_data_lake"

  bucket_name           = local.bucket_name
  datalake_prefixes     = local.datalake_prefixes
  athena_results_prefix = var.athena_results_prefix
  tags                  = local.default_tags
}

# ─── IAM Roles e Policies ───────────────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  project_name        = var.project_name
  environment         = var.environment
  datalake_bucket_arn = module.s3_data_lake.bucket_arn
  tags                = local.default_tags
}

# ─── CloudWatch Log Groups ──────────────────────────────────────────────────
module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.default_tags
}

# ─── Lambda de Ingestão ─────────────────────────────────────────────────────
module "lambda_ingestion" {
  source = "./modules/lambda_ingestion"

  project_name    = var.project_name
  environment     = var.environment
  lambda_role_arn = module.iam.lambda_role_arn
  lambda_timeout  = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  datalake_bucket = module.s3_data_lake.bucket_name
  log_group_arn   = module.cloudwatch.lambda_log_group_arn
  tags            = local.default_tags

  depends_on = [module.cloudwatch]
}

# ─── EventBridge (agendamento) ──────────────────────────────────────────────
module "eventbridge" {
  source = "./modules/eventbridge"

  project_name        = var.project_name
  environment         = var.environment
  schedule_expression = var.lambda_schedule_expression
  lambda_arn          = module.lambda_ingestion.function_arn
  lambda_name         = module.lambda_ingestion.function_name
  tags                = local.default_tags
}

# ─── Glue Catalog ───────────────────────────────────────────────────────────
module "glue_catalog" {
  source = "./modules/glue_catalog"

  database_name   = local.glue_database_name
  datalake_bucket = module.s3_data_lake.bucket_name
  glue_role_arn   = module.iam.glue_role_arn
  tags            = local.default_tags
}

# ─── Athena ─────────────────────────────────────────────────────────────────
module "athena" {
  source = "./modules/athena"

  project_name          = var.project_name
  environment           = var.environment
  datalake_bucket       = module.s3_data_lake.bucket_name
  athena_results_prefix = var.athena_results_prefix
  tags                  = local.default_tags
}
