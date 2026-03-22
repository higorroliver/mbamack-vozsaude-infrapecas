###############################################################################
# Módulo: IAM — roles e policies para Lambda, Glue e Athena
###############################################################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ─── Lambda Role ─────────────────────────────────────────────────────────────

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.project_name}-${var.environment}-lambda-ingestion"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = var.tags
}

# Policy: acesso ao S3 data lake (leitura e escrita nos prefixos)
data "aws_iam_policy_document" "lambda_s3" {
  statement {
    sid    = "S3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [var.datalake_bucket_arn]
  }

  statement {
    sid    = "S3ReadWriteObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.datalake_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_s3" {
  name   = "${var.project_name}-lambda-s3-access"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_s3.json
}

# Policy: logs no CloudWatch
data "aws_iam_policy_document" "lambda_logs" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-${var.environment}-*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-${var.environment}-*:*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_logs" {
  name   = "${var.project_name}-lambda-cloudwatch"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_logs.json
}

# ─── Glue Role ───────────────────────────────────────────────────────────────

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue" {
  name               = "${var.project_name}-${var.environment}-glue"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
  tags               = var.tags
}

# Policy: acesso ao S3 para Glue (leitura)
data "aws_iam_policy_document" "glue_s3" {
  statement {
    sid    = "S3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [var.datalake_bucket_arn]
  }

  statement {
    sid    = "S3ReadObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${var.datalake_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "glue_s3" {
  name   = "${var.project_name}-glue-s3-access"
  role   = aws_iam_role.glue.id
  policy = data.aws_iam_policy_document.glue_s3.json
}

# Policy: Glue service permissions
data "aws_iam_policy_document" "glue_service" {
  statement {
    sid    = "GlueCatalogAccess"
    effect = "Allow"
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:BatchGetPartition",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:CreatePartition",
      "glue:UpdatePartition",
      "glue:DeletePartition",
      "glue:BatchCreatePartition",
    ]
    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*",
    ]
  }

  statement {
    sid    = "CloudWatchLogsGlue"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/*:*",
    ]
  }
}

resource "aws_iam_role_policy" "glue_service" {
  name   = "${var.project_name}-glue-service"
  role   = aws_iam_role.glue.id
  policy = data.aws_iam_policy_document.glue_service.json
}
