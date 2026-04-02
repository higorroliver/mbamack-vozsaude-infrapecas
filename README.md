# Vozes da Saúde — Infraestrutura (IaC)

Repositório de infraestrutura como código (Terraform) para o projeto **Vozes da Saúde**, que coleta, processa, armazena e disponibiliza dados de avaliações públicas de UBS em São Paulo.

## Arquitetura

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────────────────────┐
│ EventBridge │────▶│    Lambda     │────▶│         S3 Data Lake            │
│  (schedule) │     │  (ingestão)  │     │  raw/ bronze/ silver/ gold/     │
└─────────────┘     └──────────────┘     │  artifacts/ logs/              │
                           │              └────────────┬──────────────────┘
                           ▼                           │
                    ┌──────────────┐            ┌──────┴───────┐
                    │  CloudWatch  │            │ Glue Catalog │
                    │   (logs)     │            │  (crawlers)  │
                    └──────────────┘            └──────┬───────┘
                                                       │
                                                ┌──────┴───────┐
                                                │    Athena     │
                                                │  (consultas)  │
                                                └───────────────┘
```

### Serviços AWS utilizados

| Serviço      | Finalidade                                      | Custo estimado    |
| ------------ | ----------------------------------------------- | ----------------- |
| S3           | Data lake com camadas medallion                 | Muito baixo       |
| Lambda       | Função de ingestão de dados                     | Free tier / baixo |
| EventBridge  | Agendamento periódico da ingestão               | Gratuito          |
| IAM          | Roles e policies com menor privilégio            | Gratuito          |
| CloudWatch   | Logs de execução da Lambda e Glue               | Free tier / baixo |
| Glue Catalog | Catálogo de dados e crawlers                    | Free tier / baixo |
| Athena       | Consultas SQL sobre o data lake                 | Pay per query     |

### Serviços evitados (custo/complexidade)

- EKS, MSK, Redshift, NAT Gateway, EC2, ECS/Fargate
- VPC complexa, múltiplos ambientes

## Estrutura do projeto

```
terraform/
├── main.tf                        # Orquestração dos módulos
├── providers.tf                   # Provider AWS
├── versions.tf                    # Versões do Terraform e providers
├── variables.tf                   # Variáveis globais
├── locals.tf                      # Padronização de nomes e tags
├── outputs.tf                     # Outputs globais
├── terraform.tfvars.example       # Exemplo de variáveis
├── lambda/
│   └── ingestion/
│       └── handler.py             # Código placeholder da Lambda
└── modules/
    ├── s3_data_lake/              # Bucket S3 com modelo medallion
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam/                       # Roles e policies (Lambda, Glue)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── lambda_ingestion/          # Função Lambda de ingestão
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── eventbridge/               # Agendamento EventBridge
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── cloudwatch/                # Log groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── glue_catalog/              # Glue database e crawlers
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── athena/                    # Workgroup Athena
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Recursos criados

Ao executar `terraform apply`, os seguintes recursos são provisionados:

### S3 Data Lake
- Bucket S3 com versionamento habilitado
- Bloqueio total de acesso público
- Criptografia SSE-S3 (AES256)
- Prefixos: `raw/`, `bronze/`, `silver/`, `gold/`, `artifacts/`, `logs/`, `athena-results/`

### IAM
- Role para Lambda com acesso ao S3 e CloudWatch Logs
- Role para Glue com acesso ao S3 (leitura) e Glue Catalog
- Políticas com menor privilégio possível

### Lambda
- Função Python 3.12 (placeholder para ingestão)
- Variáveis de ambiente configuradas
- Timeout e memória parametrizáveis

### EventBridge
- Regra de agendamento periódico (padrão: 1x ao dia)
- Target apontando para a Lambda de ingestão
- Expressão cron/rate configurável

### CloudWatch
- Log group para Lambda (`/aws/lambda/...`)
- Log group para Glue (`/aws-glue/...`)
- Retenção de 14 dias

### Glue Catalog
- Database no Glue Catalog
- Crawlers para camadas bronze, silver e gold
- Schema change policy configurada

### Athena
- Workgroup com output configurado no S3
- Enforce workgroup configuration habilitado

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.7.0
- AWS CLI configurado com credenciais do Learner Lab
- Permissões IAM suficientes para criar os recursos acima

## Como usar

### 1. Configurar variáveis

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores (especialmente bucket_name)
```

> **Importante:** O nome do bucket S3 deve ser globalmente único. Adicione um sufixo único como seu RA ou timestamp.

### 2. Inicializar

```bash
./scripts/tf.sh init
# ou
cd terraform && terraform init
```

### 3. Validar

```bash
./scripts/tf.sh validate
# ou
cd terraform && terraform init -backend=false && terraform validate
```

### 4. Planejar

```bash
./scripts/tf.sh plan
# ou
cd terraform && terraform plan -var-file=terraform.tfvars -out=tfplan
```

### 5. Aplicar

```bash
./scripts/tf.sh apply
# ou
cd terraform && terraform apply tfplan
```

### 6. Destruir (quando necessário)

```bash
./scripts/tf.sh destroy
# ou
cd terraform && terraform destroy -var-file=terraform.tfvars
```

### Formatar código

```bash
./scripts/tf.sh fmt
```

## Tags padrão

Todos os recursos recebem as seguintes tags:

| Tag         | Valor                          |
| ----------- | ------------------------------ |
| project     | vozes-da-saude                 |
| environment | lab                            |
| managed_by  | terraform                      |
| repository  | mbamack-vozsaude-infrapecas    |
| owner       | mba-mackenzie                  |

## Variáveis disponíveis

| Variável                     | Tipo       | Default                | Descrição                                        |
| ---------------------------- | ---------- | ---------------------- | ------------------------------------------------ |
| `aws_region`                 | string     | `us-east-1`            | Região AWS                                       |
| `project_name`               | string     | `vozes-da-saude`       | Nome do projeto (prefixo)                        |
| `environment`                | string     | `lab`                  | Ambiente de execução                             |
| `owner`                      | string     | `mba-mackenzie`        | Responsável pelo projeto                         |
| `bucket_name`                | string     | `vozes-da-saude-datalake` | Nome do bucket S3 (globalmente único)         |
| `lambda_schedule_expression` | string     | `rate(1 day)`          | Agendamento da Lambda (EventBridge)              |
| `athena_results_prefix`      | string     | `athena-results`       | Prefixo S3 para resultados Athena                |
| `lambda_timeout`             | number     | `300`                  | Timeout da Lambda (segundos)                     |
| `lambda_memory_size`         | number     | `256`                  | Memória da Lambda (MB)                           |
| `tags`                       | map(string)| `{}`                   | Tags adicionais                                  |
