# =============================================================================
# AWS SQS Queue Module - Production Ready with Security Best Practices
# =============================================================================
# This file contains ONLY the main SQS queue resources

# -----------------------------------------------------------------------------
# Dead Letter Queue (DLQ)
# -----------------------------------------------------------------------------
resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                              = local.dlq_name
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.fifo_queue ? var.dlq_content_based_deduplication : null
  deduplication_scope               = var.fifo_queue && var.dlq_deduplication_scope != null ? var.dlq_deduplication_scope : null
  fifo_throughput_limit             = var.fifo_queue && var.dlq_fifo_throughput_limit != null ? var.dlq_fifo_throughput_limit : null
  message_retention_seconds         = var.dlq_message_retention_seconds
  visibility_timeout_seconds        = var.dlq_visibility_timeout_seconds
  kms_master_key_id                 = local.kms_key_id
  kms_data_key_reuse_period_seconds = local.enable_encryption && !var.use_sqs_managed_sse ? var.kms_data_key_reuse_period_seconds : null
  sqs_managed_sse_enabled           = var.use_sqs_managed_sse && !local.enable_encryption ? true : null

  tags = merge(
    local.common_tags,
    {
      Name = local.dlq_name
      Type = "DeadLetterQueue"
    }
  )
}

# -----------------------------------------------------------------------------
# Main SQS Queue
# -----------------------------------------------------------------------------
resource "aws_sqs_queue" "this" {
  name                        = local.queue_name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope         = var.fifo_queue && var.deduplication_scope != null ? var.deduplication_scope : null
  fifo_throughput_limit       = var.fifo_queue && var.fifo_throughput_limit != null ? var.fifo_throughput_limit : null

  # Timing Configuration
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Encryption Configuration
  kms_master_key_id                 = local.kms_key_id
  kms_data_key_reuse_period_seconds = local.enable_encryption && !var.use_sqs_managed_sse ? var.kms_data_key_reuse_period_seconds : null
  sqs_managed_sse_enabled           = var.use_sqs_managed_sse && !local.enable_encryption ? true : null

  # Dead Letter Queue Configuration
  redrive_policy = var.create_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  # Redrive Allow Policy (controls which queues can use this as DLQ)
  redrive_allow_policy = var.redrive_allow_policy != null ? jsonencode(var.redrive_allow_policy) : null

  tags = merge(
    local.common_tags,
    {
      Name = local.queue_name
    }
  )
}
