# =============================================================================
# Outputs - SQS Module
# =============================================================================

# -----------------------------------------------------------------------------
# Queue Information
# -----------------------------------------------------------------------------
output "queue_id" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "Name of the SQS queue"
  value       = aws_sqs_queue.this.name
}

output "queue_url" {
  description = "URL of the SQS queue (same as queue_id)"
  value       = aws_sqs_queue.this.url
}

# -----------------------------------------------------------------------------
# Dead Letter Queue Information
# -----------------------------------------------------------------------------
output "dlq_id" {
  description = "URL of the Dead Letter Queue"
  value       = try(aws_sqs_queue.dlq[0].id, null)
}

output "dlq_arn" {
  description = "ARN of the Dead Letter Queue"
  value       = try(aws_sqs_queue.dlq[0].arn, null)
}

output "dlq_name" {
  description = "Name of the Dead Letter Queue"
  value       = try(aws_sqs_queue.dlq[0].name, null)
}

output "dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = try(aws_sqs_queue.dlq[0].url, null)
}

# -----------------------------------------------------------------------------
# Encryption Information
# -----------------------------------------------------------------------------
output "kms_key_id" {
  description = "ID of the KMS key used for encryption"
  value       = local.kms_key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  value       = local.kms_key_id
}

output "kms_key_alias" {
  description = "Alias of the KMS key used for encryption"
  value       = try(aws_kms_alias.sqs[0].name, null)
}

# -----------------------------------------------------------------------------
# IAM Policy Information
# -----------------------------------------------------------------------------
output "consumer_policy_arn" {
  description = "ARN of the IAM policy for consumers"
  value       = try(aws_iam_policy.consumer[0].arn, null)
}

output "consumer_policy_id" {
  description = "ID of the IAM policy for consumers"
  value       = try(aws_iam_policy.consumer[0].id, null)
}

output "consumer_policy_name" {
  description = "Name of the IAM policy for consumers"
  value       = try(aws_iam_policy.consumer[0].name, null)
}

output "producer_policy_arn" {
  description = "ARN of the IAM policy for producers"
  value       = try(aws_iam_policy.producer[0].arn, null)
}

output "producer_policy_id" {
  description = "ID of the IAM policy for producers"
  value       = try(aws_iam_policy.producer[0].id, null)
}

output "producer_policy_name" {
  description = "Name of the IAM policy for producers"
  value       = try(aws_iam_policy.producer[0].name, null)
}

output "full_access_policy_arn" {
  description = "ARN of the IAM policy for full access"
  value       = try(aws_iam_policy.full_access[0].arn, null)
}

output "full_access_policy_id" {
  description = "ID of the IAM policy for full access"
  value       = try(aws_iam_policy.full_access[0].id, null)
}

output "full_access_policy_name" {
  description = "Name of the IAM policy for full access"
  value       = try(aws_iam_policy.full_access[0].name, null)
}

output "dlq_consumer_policy_arn" {
  description = "ARN of the IAM policy for DLQ consumers"
  value       = try(aws_iam_policy.dlq_consumer[0].arn, null)
}

output "dlq_consumer_policy_id" {
  description = "ID of the IAM policy for DLQ consumers"
  value       = try(aws_iam_policy.dlq_consumer[0].id, null)
}

output "dlq_consumer_policy_name" {
  description = "Name of the IAM policy for DLQ consumers"
  value       = try(aws_iam_policy.dlq_consumer[0].name, null)
}

# -----------------------------------------------------------------------------
# CloudWatch Alarms
# -----------------------------------------------------------------------------
output "alarm_age_of_oldest_message_arn" {
  description = "ARN of the age of oldest message alarm"
  value       = try(aws_cloudwatch_metric_alarm.age_of_oldest_message[0].arn, null)
}

output "alarm_messages_visible_arn" {
  description = "ARN of the messages visible alarm"
  value       = try(aws_cloudwatch_metric_alarm.messages_visible[0].arn, null)
}

output "alarm_dlq_messages_arn" {
  description = "ARN of the DLQ messages alarm"
  value       = try(aws_cloudwatch_metric_alarm.dlq_messages[0].arn, null)
}

output "alarm_messages_sent_arn" {
  description = "ARN of the messages sent alarm"
  value       = try(aws_cloudwatch_metric_alarm.messages_sent[0].arn, null)
}

output "alarm_empty_receives_arn" {
  description = "ARN of the empty receives alarm"
  value       = try(aws_cloudwatch_metric_alarm.empty_receives[0].arn, null)
}

output "cloudwatch_dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = try(aws_cloudwatch_dashboard.sqs[0].dashboard_arn, null)
}

# -----------------------------------------------------------------------------
# Queue Configuration (for reference)
# -----------------------------------------------------------------------------
output "queue_configuration" {
  description = "Complete queue configuration for reference"
  value = {
    queue_name                 = aws_sqs_queue.this.name
    queue_url                  = aws_sqs_queue.this.url
    fifo_queue                 = var.fifo_queue
    visibility_timeout_seconds = var.visibility_timeout_seconds
    message_retention_seconds  = var.message_retention_seconds
    receive_wait_time_seconds  = var.receive_wait_time_seconds
    delay_seconds              = var.delay_seconds
    max_message_size           = var.max_message_size
    encryption_enabled         = local.enable_encryption
    dlq_enabled                = var.create_dlq
    dlq_max_receive_count      = var.max_receive_count
  }
}

# -----------------------------------------------------------------------------
# Connection Information (for applications)
# -----------------------------------------------------------------------------
output "connection_info" {
  description = "Connection information for applications"
  value = {
    queue_url     = aws_sqs_queue.this.url
    queue_arn     = aws_sqs_queue.this.arn
    dlq_url       = try(aws_sqs_queue.dlq[0].url, null)
    dlq_arn       = try(aws_sqs_queue.dlq[0].arn, null)
    region        = data.aws_region.current.region
    kms_key_id    = local.kms_key_id
    is_fifo_queue = var.fifo_queue
  }
}

# -----------------------------------------------------------------------------
# Monitoring URLs
# -----------------------------------------------------------------------------
output "cloudwatch_dashboard_url" {
  description = "URL to CloudWatch dashboard"
  value       = var.create_cloudwatch_dashboard ? "https://console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.region}#dashboards:name=${aws_cloudwatch_dashboard.sqs[0].dashboard_name}" : null
}

output "queue_console_url" {
  description = "URL to queue in AWS Console"
  value       = "https://console.aws.amazon.com/sqs/v2/home?region=${data.aws_region.current.region}#/queues/${urlencode(aws_sqs_queue.this.url)}"
}

output "dlq_console_url" {
  description = "URL to DLQ in AWS Console"
  value       = var.create_dlq ? "https://console.aws.amazon.com/sqs/v2/home?region=${data.aws_region.current.region}#/queues/${urlencode(aws_sqs_queue.dlq[0].url)}" : null
}
