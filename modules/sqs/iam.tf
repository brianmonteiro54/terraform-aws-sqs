# =============================================================================
# IAM Policies for SQS Access (Least Privilege)
# =============================================================================

# -----------------------------------------------------------------------------
# IAM Policy Document - Consumer (Read-Only)
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "consumer" {
  count = var.create_iam_policies ? 1 : 0

  # Allow receiving and deleting messages
  statement {
    sid    = "AllowSQSConsumerActions"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibilityBatch"
    ]

    resources = [
      aws_sqs_queue.this.arn
    ]
  }

  # Allow KMS decryption if encryption is enabled
  dynamic "statement" {
    for_each = local.enable_encryption && !var.use_sqs_managed_sse && local.kms_key_id != null ? [1] : []
    content {
      sid    = "AllowKMSDecryption"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]

      resources = [
        local.kms_key_id
      ]
    }
  }
}

resource "aws_iam_policy" "consumer" {
  count = var.create_iam_policies ? 1 : 0

  name        = "${local.queue_name}-consumer-policy"
  description = "IAM policy for consuming messages from SQS queue ${local.queue_name}"
  policy      = data.aws_iam_policy_document.consumer[0].json

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# IAM Policy Document - Producer (Write-Only)
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "producer" {
  count = var.create_iam_policies ? 1 : 0

  # Allow sending messages
  statement {
    sid    = "AllowSQSProducerActions"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessageBatch"
    ]

    resources = [
      aws_sqs_queue.this.arn
    ]
  }

  # Allow KMS encryption if encryption is enabled
  dynamic "statement" {
    for_each = local.enable_encryption && !var.use_sqs_managed_sse && local.kms_key_id != null ? [1] : []
    content {
      sid    = "AllowKMSEncryption"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey"
      ]

      resources = [
        local.kms_key_id
      ]
    }
  }
}

resource "aws_iam_policy" "producer" {
  count = var.create_iam_policies ? 1 : 0

  name        = "${local.queue_name}-producer-policy"
  description = "IAM policy for sending messages to SQS queue ${local.queue_name}"
  policy      = data.aws_iam_policy_document.producer[0].json

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# IAM Policy Document - Full Access
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "full_access" {
  count = var.create_iam_policies ? 1 : 0

  # Allow all SQS actions
  statement {
    sid    = "AllowSQSFullAccess"
    effect = "Allow"

    actions = [
      "sqs:*"
    ]

    resources = [
      aws_sqs_queue.this.arn
    ]
  }

  # Allow KMS operations if encryption is enabled
  dynamic "statement" {
    for_each = local.enable_encryption && !var.use_sqs_managed_sse && local.kms_key_id != null ? [1] : []
    content {
      sid    = "AllowKMSOperations"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey",
        "kms:CreateGrant"
      ]

      resources = [
        local.kms_key_id
      ]
    }
  }

  # Include DLQ access if DLQ is created
  dynamic "statement" {
    for_each = var.create_dlq ? [1] : []
    content {
      sid    = "AllowDLQAccess"
      effect = "Allow"

      actions = [
        "sqs:*"
      ]

      resources = [
        aws_sqs_queue.dlq[0].arn
      ]
    }
  }
}

resource "aws_iam_policy" "full_access" {
  count = var.create_iam_policies ? 1 : 0

  name        = "${local.queue_name}-full-access-policy"
  description = "IAM policy for full access to SQS queue ${local.queue_name}"
  policy      = data.aws_iam_policy_document.full_access[0].json

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# IAM Policy Document - DLQ Consumer
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "dlq_consumer" {
  count = var.create_dlq && var.create_iam_policies ? 1 : 0

  # Allow receiving and deleting messages from DLQ
  statement {
    sid    = "AllowDLQConsumerActions"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibilityBatch"
    ]

    resources = [
      aws_sqs_queue.dlq[0].arn
    ]
  }

  # Allow KMS decryption if encryption is enabled
  dynamic "statement" {
    for_each = local.enable_encryption && !var.use_sqs_managed_sse && local.kms_key_id != null ? [1] : []
    content {
      sid    = "AllowKMSDecryption"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]

      resources = [
        local.kms_key_id
      ]
    }
  }
}

resource "aws_iam_policy" "dlq_consumer" {
  count = var.create_dlq && var.create_iam_policies ? 1 : 0

  name        = "${local.dlq_name}-consumer-policy"
  description = "IAM policy for consuming messages from Dead Letter Queue ${local.dlq_name}"
  policy      = data.aws_iam_policy_document.dlq_consumer[0].json

  tags = local.common_tags
}
