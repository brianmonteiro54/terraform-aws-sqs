# =============================================================================
# Local Variables
# =============================================================================

locals {
  # Merge default tags with custom tags
  common_tags = merge(
    {
      Module      = "terraform-aws-sqs"
      ManagedBy   = "Terraform"
      Environment = var.environment
      CostCenter  = var.cost_center
    },
    var.tags
  )

  # Queue name with optional prefix and suffix for FIFO
  queue_name = var.fifo_queue ? "${var.queue_name_prefix}${var.queue_name}.fifo" : "${var.queue_name_prefix}${var.queue_name}"

  # Dead Letter Queue name
  dlq_name = var.fifo_queue ? "${var.queue_name_prefix}${var.queue_name}-dlq.fifo" : "${var.queue_name_prefix}${var.queue_name}-dlq"

  # Encryption logic - same as DynamoDB module
  enable_encryption = var.enable_encryption || var.kms_master_key_id != null

  # KMS key ID to use (customer-managed, AWS-managed, or SQS-managed)
  kms_key_id = local.enable_encryption && !var.use_sqs_managed_sse ? (
    var.kms_master_key_id != null ? var.kms_master_key_id : (
      var.create_kms_key ? aws_kms_key.sqs[0].id : null
    )
  ) : null
}
