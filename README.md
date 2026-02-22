# 📨 Terraform AWS SQS

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.31-FF9900?logo=amazonaws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **FIAP — Pós Tech · Tech Challenge — Fase 03 · ToggleMaster**
>
> Módulo Terraform para provisionamento de filas **Amazon SQS** com Dead Letter Queue, criptografia, políticas e monitoramento.

---

## 📋 Descrição

Módulo completo para filas SQS com:

- **Standard Queue** com configurações de timing customizáveis
- **Dead Letter Queue (DLQ)** para mensagens que falharam
- **Criptografia** SSE-SQS ou SSE-KMS (CMK)
- **Queue Policies** com enforce SSL
- **CloudWatch Alarms** para profundidade da fila e idade das mensagens
- **CloudWatch Dashboard** para visualização de métricas
- **IAM Policies** para acesso granular

---

## 📦 Recursos Criados

| Recurso | Descrição |
|---------|-----------|
| `aws_sqs_queue` | Fila SQS principal |
| `aws_sqs_queue` (DLQ) | Dead Letter Queue (opcional) |
| `aws_sqs_queue_policy` | Política com enforce SSL |
| `aws_kms_key` / `aws_kms_alias` | Chave KMS (opcional) |
| `aws_cloudwatch_metric_alarm` | Alarmes de monitoramento |
| `aws_cloudwatch_dashboard` | Dashboard de métricas (opcional) |
| `aws_iam_policy` | Políticas de acesso IAM (opcional) |

---

## 🚀 Uso

```hcl
module "sqs_events" {
  source = "github.com/brianmonteiro54/terraform-aws-sqs//modules/sqs?ref=<commit-sha>"

  queue_name  = "togglemaster-events"
  environment = "production"

  visibility_timeout_seconds = 300
  message_retention_seconds  = 345600   # 4 dias
  receive_wait_time_seconds  = 20       # Long polling

  create_dlq        = false
  max_receive_count = 3

  use_sqs_managed_sse = true
  enable_encryption   = true
  create_kms_key      = false
  enforce_ssl         = true

  enable_cloudwatch_alarms    = true
  create_cloudwatch_dashboard = true
}
```

---

## 📁 Estrutura

```
terraform-aws-sqs/
├── modules/
│   └── sqs/
│       ├── main.tf
│       ├── policies.tf
│       ├── kms.tf
│       ├── alarms.tf
│       ├── iam.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       ├── data.tf
│       └── versions.tf
├── .github/workflows/
│   └── terraform-ci.yml
└── LICENSE
```

---

## 📄 Licença

[MIT License](LICENSE)
