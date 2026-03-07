#!/usr/bin/env bash
set -euo pipefail

# Uso:
#   ./scripts/tf.sh init
#   ./scripts/tf.sh plan
#   ./scripts/tf.sh apply
#   ./scripts/tf.sh destroy
#   ./scripts/tf.sh validate
#   ./scripts/tf.sh fmt

cd "$(dirname "$0")/../terraform"

case "${1:-}" in
  fmt)
    terraform fmt -recursive
    ;;
  validate)
    terraform init -backend=false
    terraform validate
    ;;
  init)
    terraform init
    ;;
  plan)
    terraform init
    terraform plan -var-file=terraform.tfvars -out=tfplan
    ;;
  apply)
    terraform init
    terraform apply tfplan
    ;;
  destroy)
    terraform init
    terraform destroy -var-file=terraform.tfvars
    ;;
  *)
    echo "Uso: $0 {fmt|validate|init|plan|apply|destroy}"
    exit 1
    ;;
esac