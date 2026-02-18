# =============================================================================
# Variables - SQS Module
# =============================================================================

# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------
variable "queue_name" {
  description = "Name of the SQS queue (without .fifo suffix for FIFO queues)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.queue_name))
    error_message = "Queue name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.queue_name) >= 1 && length(var.queue_name) <= 80
    error_message = "Queue name must be between 1 and 80 characters."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string

  validation {
    condition     = can(regex("^(dev|development|staging|stage|prod|production|qa|test)$", var.environment))
    error_message = "Environment must be one of: dev, development, staging, stage, prod, production, qa, test."
  }
}

# -----------------------------------------------------------------------------
# Optional Variables - Queue Configuration
# -----------------------------------------------------------------------------
variable "queue_name_prefix" {
  description = "Prefix to add to queue name (useful for multi-environment deployments)"
  type        = string
  default     = ""
}

variable "fifo_queue" {
  description = "Enable FIFO queue (First-In-First-Out)"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Deduplication scope for high throughput FIFO queues (messageGroup or queue)"
  type        = string
  default     = null

  validation {
    condition     = var.deduplication_scope == null || try(contains(["messageGroup", "queue"], var.deduplication_scope), false)
    error_message = "Deduplication scope must be either 'messageGroup' or 'queue'."
  }
}

variable "fifo_throughput_limit" {
  description = "Throughput limit for high throughput FIFO queues (perQueue or perMessageGroupId)"
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "FIFO throughput limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

# -----------------------------------------------------------------------------
# Timing Configuration
# -----------------------------------------------------------------------------
variable "delay_seconds" {
  description = "Delay in seconds for message delivery (0-900)"
  type        = number
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "Delay seconds must be between 0 and 900 (15 minutes)."
  }
}

variable "max_message_size" {
  description = "Maximum message size in bytes (1024-262144)"
  type        = number
  default     = 262144

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "Max message size must be between 1024 bytes (1 KB) and 262144 bytes (256 KB)."
  }
}

variable "message_retention_seconds" {
  description = "Message retention period in seconds (60-1209600)"
  type        = number
  default     = 345600 # 4 days

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "Message retention must be between 60 seconds (1 minute) and 1209600 seconds (14 days)."
  }
}

variable "receive_wait_time_seconds" {
  description = "Wait time for long polling in seconds (0-20)"
  type        = number
  default     = 20

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "Receive wait time must be between 0 and 20 seconds."
  }
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds (0-43200)"
  type        = number
  default     = 300

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "Visibility timeout must be between 0 and 43200 seconds (12 hours)."
  }
}

# -----------------------------------------------------------------------------
# Encryption Configuration
# -----------------------------------------------------------------------------
variable "enable_encryption" {
  description = "Enable server-side encryption with KMS"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Controls if a custom KMS key should be created. Set to false to use AWS Managed Key (alias/aws/sqs) or SQS-managed SSE"
  type        = bool
  default     = true
}

variable "use_sqs_managed_sse" {
  description = "Use SQS-managed server-side encryption (SSE-SQS) instead of KMS"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "ID or ARN of the KMS key for encryption. If not provided, a new key will be created if encryption is enabled"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Length of time in seconds for which SQS can reuse a data key (60-86400)"
  type        = number
  default     = 300

  validation {
    condition     = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400
    error_message = "KMS data key reuse period must be between 60 and 86400 seconds (1 day)."
  }
}

variable "kms_deletion_window_in_days" {
  description = "Duration in days after which the KMS key is deleted after destruction of the resource"
  type        = number
  default     = 30

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

variable "enable_multi_region" {
  description = "Enable multi-region KMS key"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Dead Letter Queue Configuration
# -----------------------------------------------------------------------------
variable "create_dlq" {
  description = "Create a Dead Letter Queue for failed messages"
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "Maximum number of receives before sending to DLQ (1-1000)"
  type        = number
  default     = 3

  validation {
    condition     = var.max_receive_count >= 1 && var.max_receive_count <= 1000
    error_message = "Max receive count must be between 1 and 1000."
  }
}

variable "dlq_message_retention_seconds" {
  description = "Message retention period for DLQ in seconds (60-1209600)"
  type        = number
  default     = 1209600 # 14 days (maximum)

  validation {
    condition     = var.dlq_message_retention_seconds >= 60 && var.dlq_message_retention_seconds <= 1209600
    error_message = "DLQ message retention must be between 60 seconds and 1209600 seconds (14 days)."
  }
}

variable "dlq_visibility_timeout_seconds" {
  description = "Visibility timeout for DLQ in seconds"
  type        = number
  default     = 300

  validation {
    condition     = var.dlq_visibility_timeout_seconds >= 0 && var.dlq_visibility_timeout_seconds <= 43200
    error_message = "DLQ visibility timeout must be between 0 and 43200 seconds."
  }
}

variable "dlq_content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO DLQ"
  type        = bool
  default     = false
}

variable "dlq_deduplication_scope" {
  description = "Deduplication scope for high throughput FIFO DLQ"
  type        = string
  default     = null
}

variable "dlq_fifo_throughput_limit" {
  description = "Throughput limit for high throughput FIFO DLQ"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Queue Policy Configuration
# -----------------------------------------------------------------------------
variable "create_queue_policy" {
  description = "Create a queue policy for access control"
  type        = bool
  default     = true
}

variable "create_dlq_policy" {
  description = "Create a policy for the Dead Letter Queue"
  type        = bool
  default     = true
}

variable "allowed_services" {
  description = "List of AWS services allowed to send messages to the queue (e.g., sns, events)"
  type        = list(string)
  default     = []
}

variable "service_source_arns" {
  description = "Map of service names to source ARNs for condition checking"
  type        = map(list(string))
  default     = {}
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to access the queue"
  type        = list(string)
  default     = []
}

variable "allowed_account_actions" {
  description = "List of SQS actions allowed for external accounts"
  type        = list(string)
  default = [
    "sqs:SendMessage",
    "sqs:ReceiveMessage"
  ]
}

variable "enforce_ssl" {
  description = "Enforce SSL/TLS for all queue access"
  type        = bool
  default     = true
}

variable "redrive_allow_policy" {
  description = "Policy controlling which source queues can use this queue as DLQ"
  type = object({
    redrivePermission = string
    sourceQueueArns   = optional(list(string))
  })
  default = null
}

# -----------------------------------------------------------------------------
# IAM Policy Configuration
# -----------------------------------------------------------------------------
variable "create_iam_policies" {
  description = "Create IAM policies for queue access (consumer, producer, full_access)"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# CloudWatch Monitoring
# -----------------------------------------------------------------------------
variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms for monitoring"
  type        = bool
  default     = true
}

variable "alarm_age_of_oldest_message" {
  description = "Configuration for age of oldest message alarm"
  type = object({
    threshold          = number
    evaluation_periods = number
    period             = number
  })
  default = {
    threshold          = 300 # 5 minutes
    evaluation_periods = 2
    period             = 300
  }
}

variable "alarm_messages_visible" {
  description = "Configuration for messages visible alarm (queue depth)"
  type = object({
    threshold          = number
    evaluation_periods = number
    period             = number
  })
  default = {
    threshold          = 1000
    evaluation_periods = 2
    period             = 300
  }
}

variable "alarm_dlq_messages" {
  description = "Configuration for DLQ messages alarm"
  type = object({
    threshold          = number
    evaluation_periods = number
    period             = number
  })
  default = {
    threshold          = 1
    evaluation_periods = 1
    period             = 300
  }
}

variable "alarm_messages_sent" {
  description = "Configuration for messages sent alarm (activity monitoring)"
  type = object({
    threshold          = number
    evaluation_periods = number
    period             = number
  })
  default = {
    threshold          = 1
    evaluation_periods = 3
    period             = 900
  }
}

variable "alarm_empty_receives" {
  description = "Configuration for empty receives alarm (efficiency monitoring)"
  type = object({
    threshold          = number
    evaluation_periods = number
    period             = number
  })
  default = {
    threshold          = 1000
    evaluation_periods = 2
    period             = 300
  }
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarm transitions to ALARM state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of ARNs to notify when alarm transitions to OK state"
  type        = list(string)
  default     = []
}

variable "enable_activity_monitoring" {
  description = "Enable monitoring for queue activity (messages sent)"
  type        = bool
  default     = false
}

variable "enable_efficiency_monitoring" {
  description = "Enable monitoring for polling efficiency (empty receives)"
  type        = bool
  default     = false
}

variable "create_cloudwatch_dashboard" {
  description = "Create a CloudWatch dashboard for queue monitoring"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Tags
# -----------------------------------------------------------------------------
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "engineering"
}
