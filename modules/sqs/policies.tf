# =============================================================================
# SQS Queue Policies (Resource-based Access Control)
# =============================================================================

# -----------------------------------------------------------------------------
# Main Queue Policy
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "queue_policy" {
  count = var.create_queue_policy ? 1 : 0

  # Allow queue owner full access
  statement {
    sid    = "QueueOwnerFullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = var.allowed_queue_actions

    resources = [
      aws_sqs_queue.this.arn
    ]
  }

  # Allow specific services to send messages
  dynamic "statement" {
    for_each = var.allowed_services
    content {
      sid    = "Allow${statement.value}ToSendMessage"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["${statement.value}.amazonaws.com"]
      }

      actions = [
        "sqs:SendMessage"
      ]

      resources = [
        aws_sqs_queue.this.arn
      ]

      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = lookup(var.service_source_arns, statement.value, ["*"])
      }
    }
  }

  # Allow specific AWS accounts
  dynamic "statement" {
    for_each = length(var.allowed_account_ids) > 0 ? [1] : []
    content {
      sid    = "AllowSpecificAccountsAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", var.allowed_account_ids)
      }

      actions = var.allowed_account_actions

      resources = [
        aws_sqs_queue.this.arn
      ]
    }
  }

  # Enforce HTTPS/TLS
  dynamic "statement" {
    for_each = var.enforce_ssl ? [1] : []
    content {
      sid    = "DenyInsecureTransport"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = var.allowed_queue_actions

      resources = [
        aws_sqs_queue.this.arn
      ]

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}

resource "aws_sqs_queue_policy" "this" {
  count = var.create_queue_policy ? 1 : 0

  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.queue_policy[0].json
}

# -----------------------------------------------------------------------------
# Dead Letter Queue Policy
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "dlq_policy" {
  count = var.create_dlq && var.create_dlq_policy ? 1 : 0

  statement {
    sid    = "DLQOwnerFullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = var.allowed_queue_actions

    resources = [
      aws_sqs_queue.dlq[0].arn
    ]
  }

  # Enforce HTTPS/TLS
  dynamic "statement" {
    for_each = var.enforce_ssl ? [1] : []
    content {
      sid    = "DenyInsecureTransport"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = var.allowed_queue_actions

      resources = [
        aws_sqs_queue.dlq[0].arn
      ]

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}

resource "aws_sqs_queue_policy" "dlq" {
  count = var.create_dlq && var.create_dlq_policy ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].id
  policy    = data.aws_iam_policy_document.dlq_policy[0].json
}
