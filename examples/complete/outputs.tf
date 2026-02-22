output "queue_url" {
  description = "URL of the SQS queue"
  value       = module.sqs.queue_url
}

output "queue_arn" {
  description = "ARN of the SQS queue"
  value       = module.sqs.queue_arn
}

output "queue_name" {
  description = "Name of the SQS queue"
  value       = module.sqs.queue_name
}

output "dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = module.sqs.dlq_url
}

output "dlq_arn" {
  description = "ARN of the Dead Letter Queue"
  value       = module.sqs.dlq_arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  value       = module.sqs.kms_key_arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = module.sqs.kms_key_alias
}

output "consumer_policy_arn" {
  description = "ARN of the consumer IAM policy (attach to consumer roles)"
  value       = module.sqs.consumer_policy_arn
}

output "producer_policy_arn" {
  description = "ARN of the producer IAM policy (attach to producer roles)"
  value       = module.sqs.producer_policy_arn
}

output "dlq_consumer_policy_arn" {
  description = "ARN of the DLQ consumer IAM policy"
  value       = module.sqs.dlq_consumer_policy_arn
}

output "alarm_dlq_messages_arn" {
  description = "ARN of the DLQ CloudWatch alarm"
  value       = module.sqs.alarm_dlq_messages_arn
}

output "cloudwatch_dashboard_url" {
  description = "URL to the CloudWatch monitoring dashboard"
  value       = module.sqs.cloudwatch_dashboard_url
}

output "queue_console_url" {
  description = "URL to the queue in the AWS Console"
  value       = module.sqs.queue_console_url
}

output "connection_info" {
  description = "Connection info for applications"
  value       = module.sqs.connection_info
}
