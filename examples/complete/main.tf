# =============================================================================
# Example: Complete SQS Queue
#
# This example provisions a production-ready SQS queue with:
#   - Dead Letter Queue (DLQ) for failed messages
#   - Customer-managed KMS key for encryption (auto-created)
#   - Queue and DLQ policies with SSL enforcement
#   - Long polling enabled (receive_wait_time_seconds = 20)
#   - Separate IAM policies for consumers, producers, and DLQ consumers
#   - CloudWatch alarms for queue depth, message age, and DLQ activity
#   - CloudWatch dashboard for full queue visibility
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply
# =============================================================================

module "sqs" {
  source = "../../modules/sqs"

  # ---------------------------------------------------
  # Required
  # ---------------------------------------------------
  queue_name  = "order-processing"
  environment = "dev"

  # ---------------------------------------------------
  # Queue Configuration
  # ---------------------------------------------------
  fifo_queue                 = false
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KB (max)
  message_retention_seconds  = 345600 # 4 days
  receive_wait_time_seconds  = 20     # Long polling (recommended)
  visibility_timeout_seconds = 300    # 5 min — match your consumer timeout

  # ---------------------------------------------------
  # Dead Letter Queue — catches messages after 3 failed attempts
  # ---------------------------------------------------
  create_dlq                     = true
  max_receive_count              = 3
  dlq_message_retention_seconds  = 1209600 # 14 days (max — keep failed msgs)
  dlq_visibility_timeout_seconds = 300

  # ---------------------------------------------------
  # Encryption — customer-managed KMS key (auto-created)
  # ---------------------------------------------------
  enable_encryption   = true
  create_kms_key      = true
  use_sqs_managed_sse = false

  # ---------------------------------------------------
  # Queue Policy
  # enforce_ssl = true blocks all non-HTTPS requests
  # ---------------------------------------------------
  create_queue_policy = true
  create_dlq_policy   = true
  enforce_ssl         = true

  # Uncomment to allow SNS to publish to this queue:
  # allowed_services = ["sns"]
  # service_source_arns = {
  #   sns = ["arn:aws:sns:us-east-1:123456789012:my-topic"]
  # }

  # ---------------------------------------------------
  # IAM Policies (attach to your application roles)
  # ---------------------------------------------------
  create_iam_policies = true

  # ---------------------------------------------------
  # CloudWatch Alarms
  # Add alarm_actions = ["arn:aws:sns:..."] for notifications
  # ---------------------------------------------------
  enable_cloudwatch_alarms = true

  alarm_age_of_oldest_message = {
    threshold          = 600 # Alert if message sits > 10 min
    evaluation_periods = 2
    period             = 300
  }

  alarm_messages_visible = {
    threshold          = 1000 # Alert if queue depth > 1000
    evaluation_periods = 2
    period             = 300
  }

  alarm_dlq_messages = {
    threshold          = 1 # Alert on ANY DLQ message
    evaluation_periods = 1
    period             = 300
  }

  # Optional: alert if queue goes quiet unexpectedly
  enable_activity_monitoring = false

  # Optional: alert on inefficient polling
  enable_efficiency_monitoring = false

  # CloudWatch dashboard with queue metrics
  create_cloudwatch_dashboard = true

  # ---------------------------------------------------
  # Tags
  # ---------------------------------------------------
  tags = {
    Project    = "my-app"
    Owner      = "platform-team"
    CostCenter = "engineering"
  }
}
