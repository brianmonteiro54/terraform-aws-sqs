# =============================================================================
# CloudWatch Alarms for SQS Monitoring
# =============================================================================

# -----------------------------------------------------------------------------
# Alarm: Age of Oldest Message
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "age_of_oldest_message" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.queue_name}-age-of-oldest-message"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_age_of_oldest_message.evaluation_periods
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = var.alarm_age_of_oldest_message.period
  statistic           = "Maximum"
  threshold           = var.alarm_age_of_oldest_message.threshold
  alarm_description   = "Triggered when the age of the oldest message exceeds ${var.alarm_age_of_oldest_message.threshold} seconds"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Alarm: Number of Messages Visible (Queue Depth)
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "messages_visible" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.queue_name}-messages-visible"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_messages_visible.evaluation_periods
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = var.alarm_messages_visible.period
  statistic           = "Average"
  threshold           = var.alarm_messages_visible.threshold
  alarm_description   = "Triggered when the number of visible messages exceeds ${var.alarm_messages_visible.threshold}"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Alarm: Dead Letter Queue Messages
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "dlq_messages" {
  count = var.create_dlq && var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.dlq_name}-messages-visible"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_dlq_messages.evaluation_periods
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = var.alarm_dlq_messages.period
  statistic           = "Average"
  threshold           = var.alarm_dlq_messages.threshold
  alarm_description   = "Triggered when messages appear in the Dead Letter Queue"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.dlq[0].name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Alarm: Number of Messages Sent (Activity Monitoring)
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "messages_sent" {
  count = var.enable_activity_monitoring && var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.queue_name}-messages-sent-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_messages_sent.evaluation_periods
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  period              = var.alarm_messages_sent.period
  statistic           = "Sum"
  threshold           = var.alarm_messages_sent.threshold
  alarm_description   = "Triggered when message activity is unexpectedly low"
  treat_missing_data  = "breaching"

  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Alarm: Number of Empty Receives (Efficiency Monitoring)
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "empty_receives" {
  count = var.enable_efficiency_monitoring && var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.queue_name}-empty-receives-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_empty_receives.evaluation_periods
  metric_name         = "NumberOfEmptyReceives"
  namespace           = "AWS/SQS"
  period              = var.alarm_empty_receives.period
  statistic           = "Sum"
  threshold           = var.alarm_empty_receives.threshold
  alarm_description   = "Triggered when too many empty receives occur (inefficient polling)"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# CloudWatch Dashboard (Optional)
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_dashboard" "sqs" {
  count = var.create_cloudwatch_dashboard ? 1 : 0

  dashboard_name = "${local.queue_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", { stat = "Average", label = "Messages Visible" }],
            [".", "ApproximateNumberOfMessagesNotVisible", { stat = "Average", label = "Messages In Flight" }],
            [".", "ApproximateNumberOfMessagesDelayed", { stat = "Average", label = "Messages Delayed" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          title   = "Queue Depth"
          period  = 300
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SQS", "NumberOfMessagesSent", { stat = "Sum", label = "Messages Sent" }],
            [".", "NumberOfMessagesReceived", { stat = "Sum", label = "Messages Received" }],
            [".", "NumberOfMessagesDeleted", { stat = "Sum", label = "Messages Deleted" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          title   = "Message Activity"
          period  = 300
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SQS", "ApproximateAgeOfOldestMessage", { stat = "Maximum", label = "Age of Oldest Message (seconds)" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          title   = "Message Age"
          period  = 300
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SQS", "NumberOfEmptyReceives", { stat = "Sum", label = "Empty Receives" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          title   = "Polling Efficiency"
          period  = 300
        }
      }
    ]
  })
}
