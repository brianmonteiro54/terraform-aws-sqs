# Example: Complete SQS Queue

This example provisions a production-ready SQS queue for order processing.

## What is created

- Standard SQS queue with long polling (`receive_wait_time_seconds = 20`)
- Dead Letter Queue (DLQ) — captures messages after 3 failed receive attempts
- Customer-managed KMS key for encryption (auto-created)
- Queue and DLQ policies enforcing HTTPS-only access
- Three IAM policies ready to attach to your application roles:
  - **consumer** — `ReceiveMessage`, `DeleteMessage`, `ChangeMessageVisibility`
  - **producer** — `SendMessage`
  - **dlq_consumer** — receive and delete from the DLQ
- CloudWatch alarms:
  - Age of oldest message > 10 minutes
  - Queue depth > 1000 messages
  - Any message lands in the DLQ
- CloudWatch dashboard with queue depth, message activity, and polling efficiency

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Sending and receiving messages

```bash
# Send a message
aws sqs send-message \
  --queue-url $(terraform output -raw queue_url) \
  --message-body '{"order_id": "123", "status": "pending"}'

# Receive messages (long poll)
aws sqs receive-message \
  --queue-url $(terraform output -raw queue_url) \
  --wait-time-seconds 20

# Check DLQ depth
aws sqs get-queue-attributes \
  --queue-url $(terraform output -raw dlq_url) \
  --attribute-names ApproximateNumberOfMessages
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| aws_region | AWS region | No (default: `us-east-1`) |

## Outputs

| Name | Description |
|------|-------------|
| queue_url | SQS queue URL for SDK/CLI use |
| dlq_url | Dead Letter Queue URL |
| consumer_policy_arn | IAM policy ARN for consumers |
| producer_policy_arn | IAM policy ARN for producers |
| cloudwatch_dashboard_url | Link to monitoring dashboard |

> **Tip:** Set `alarm_actions` with an SNS topic ARN to receive email/PagerDuty
> alerts when DLQ messages appear or queue depth spikes.

> **FIFO queues:** Set `fifo_queue = true` for ordered, exactly-once processing.
> The `.fifo` suffix is added to the queue name automatically.
