# =============================================================================
# KMS Key for SQS Encryption
# =============================================================================
resource "aws_kms_key" "sqs" {
  count = (var.kms_master_key_id == null && var.enable_encryption && var.create_kms_key) ? 1 : 0

  description             = "KMS key for SQS queue ${local.queue_name} encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true
  multi_region            = var.enable_multi_region
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "sqs" {
  count = (var.kms_master_key_id == null && var.enable_encryption && var.create_kms_key) ? 1 : 0

  name          = "alias/${local.queue_name}-sqs"
  target_key_id = aws_kms_key.sqs[0].key_id
}
