# SQS Module

Módulo Terraform para criação de SQS na AWS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_metric_alarm.age_of_oldest_message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.dlq_messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.empty_receives](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.messages_sent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.messages_visible](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.consumer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.dlq_consumer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.producer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_alias.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.consumer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dlq_consumer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dlq_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.producer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | List of ARNs to notify when alarm transitions to ALARM state | `list(string)` | `[]` | no |
| <a name="input_alarm_age_of_oldest_message"></a> [alarm\_age\_of\_oldest\_message](#input\_alarm\_age\_of\_oldest\_message) | Configuration for age of oldest message alarm | <pre>object({<br/>    threshold          = number<br/>    evaluation_periods = number<br/>    period             = number<br/>  })</pre> | <pre>{<br/>  "evaluation_periods": 2,<br/>  "period": 300,<br/>  "threshold": 300<br/>}</pre> | no |
| <a name="input_alarm_dlq_messages"></a> [alarm\_dlq\_messages](#input\_alarm\_dlq\_messages) | Configuration for DLQ messages alarm | <pre>object({<br/>    threshold          = number<br/>    evaluation_periods = number<br/>    period             = number<br/>  })</pre> | <pre>{<br/>  "evaluation_periods": 1,<br/>  "period": 300,<br/>  "threshold": 1<br/>}</pre> | no |
| <a name="input_alarm_empty_receives"></a> [alarm\_empty\_receives](#input\_alarm\_empty\_receives) | Configuration for empty receives alarm (efficiency monitoring) | <pre>object({<br/>    threshold          = number<br/>    evaluation_periods = number<br/>    period             = number<br/>  })</pre> | <pre>{<br/>  "evaluation_periods": 2,<br/>  "period": 300,<br/>  "threshold": 1000<br/>}</pre> | no |
| <a name="input_alarm_messages_sent"></a> [alarm\_messages\_sent](#input\_alarm\_messages\_sent) | Configuration for messages sent alarm (activity monitoring) | <pre>object({<br/>    threshold          = number<br/>    evaluation_periods = number<br/>    period             = number<br/>  })</pre> | <pre>{<br/>  "evaluation_periods": 3,<br/>  "period": 900,<br/>  "threshold": 1<br/>}</pre> | no |
| <a name="input_alarm_messages_visible"></a> [alarm\_messages\_visible](#input\_alarm\_messages\_visible) | Configuration for messages visible alarm (queue depth) | <pre>object({<br/>    threshold          = number<br/>    evaluation_periods = number<br/>    period             = number<br/>  })</pre> | <pre>{<br/>  "evaluation_periods": 2,<br/>  "period": 300,<br/>  "threshold": 1000<br/>}</pre> | no |
| <a name="input_allowed_account_actions"></a> [allowed\_account\_actions](#input\_allowed\_account\_actions) | List of SQS actions allowed for external accounts | `list(string)` | <pre>[<br/>  "sqs:SendMessage",<br/>  "sqs:ReceiveMessage"<br/>]</pre> | no |
| <a name="input_allowed_account_ids"></a> [allowed\_account\_ids](#input\_allowed\_account\_ids) | List of AWS account IDs allowed to access the queue | `list(string)` | `[]` | no |
| <a name="input_allowed_services"></a> [allowed\_services](#input\_allowed\_services) | List of AWS services allowed to send messages to the queue (e.g., sns, events) | `list(string)` | `[]` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center for billing purposes | `string` | `"engineering"` | no |
| <a name="input_create_cloudwatch_dashboard"></a> [create\_cloudwatch\_dashboard](#input\_create\_cloudwatch\_dashboard) | Create a CloudWatch dashboard for queue monitoring | `bool` | `false` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Create a Dead Letter Queue for failed messages | `bool` | `true` | no |
| <a name="input_create_dlq_policy"></a> [create\_dlq\_policy](#input\_create\_dlq\_policy) | Create a policy for the Dead Letter Queue | `bool` | `true` | no |
| <a name="input_create_iam_policies"></a> [create\_iam\_policies](#input\_create\_iam\_policies) | Create IAM policies for queue access (consumer, producer, full\_access) | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Controls if a custom KMS key should be created. Set to false to use AWS Managed Key (alias/aws/sqs) or SQS-managed SSE | `bool` | `true` | no |
| <a name="input_create_queue_policy"></a> [create\_queue\_policy](#input\_create\_queue\_policy) | Create a queue policy for access control | `bool` | `true` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Deduplication scope for high throughput FIFO queues (messageGroup or queue) | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | Delay in seconds for message delivery (0-900) | `number` | `0` | no |
| <a name="input_dlq_content_based_deduplication"></a> [dlq\_content\_based\_deduplication](#input\_dlq\_content\_based\_deduplication) | Enable content-based deduplication for FIFO DLQ | `bool` | `false` | no |
| <a name="input_dlq_deduplication_scope"></a> [dlq\_deduplication\_scope](#input\_dlq\_deduplication\_scope) | Deduplication scope for high throughput FIFO DLQ | `string` | `null` | no |
| <a name="input_dlq_fifo_throughput_limit"></a> [dlq\_fifo\_throughput\_limit](#input\_dlq\_fifo\_throughput\_limit) | Throughput limit for high throughput FIFO DLQ | `string` | `null` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | Message retention period for DLQ in seconds (60-1209600) | `number` | `1209600` | no |
| <a name="input_dlq_visibility_timeout_seconds"></a> [dlq\_visibility\_timeout\_seconds](#input\_dlq\_visibility\_timeout\_seconds) | Visibility timeout for DLQ in seconds | `number` | `300` | no |
| <a name="input_enable_activity_monitoring"></a> [enable\_activity\_monitoring](#input\_enable\_activity\_monitoring) | Enable monitoring for queue activity (messages sent) | `bool` | `false` | no |
| <a name="input_enable_cloudwatch_alarms"></a> [enable\_cloudwatch\_alarms](#input\_enable\_cloudwatch\_alarms) | Enable CloudWatch alarms for monitoring | `bool` | `true` | no |
| <a name="input_enable_efficiency_monitoring"></a> [enable\_efficiency\_monitoring](#input\_enable\_efficiency\_monitoring) | Enable monitoring for polling efficiency (empty receives) | `bool` | `false` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable server-side encryption with KMS | `bool` | `true` | no |
| <a name="input_enable_multi_region"></a> [enable\_multi\_region](#input\_enable\_multi\_region) | Enable multi-region KMS key | `bool` | `false` | no |
| <a name="input_enforce_ssl"></a> [enforce\_ssl](#input\_enforce\_ssl) | Enforce SSL/TLS for all queue access | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Enable FIFO queue (First-In-First-Out) | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | Throughput limit for high throughput FIFO queues (perQueue or perMessageGroupId) | `string` | `null` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | Length of time in seconds for which SQS can reuse a data key (60-86400) | `number` | `300` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | Duration in days after which the KMS key is deleted after destruction of the resource | `number` | `30` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | ID or ARN of the KMS key for encryption. If not provided, a new key will be created if encryption is enabled | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | Maximum message size in bytes (1024-262144) | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Maximum number of receives before sending to DLQ (1-1000) | `number` | `3` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | Message retention period in seconds (60-1209600) | `number` | `345600` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | List of ARNs to notify when alarm transitions to OK state | `list(string)` | `[]` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the SQS queue (without .fifo suffix for FIFO queues) | `string` | n/a | yes |
| <a name="input_queue_name_prefix"></a> [queue\_name\_prefix](#input\_queue\_name\_prefix) | Prefix to add to queue name (useful for multi-environment deployments) | `string` | `""` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | Wait time for long polling in seconds (0-20) | `number` | `20` | no |
| <a name="input_redrive_allow_policy"></a> [redrive\_allow\_policy](#input\_redrive\_allow\_policy) | Policy controlling which source queues can use this queue as DLQ | <pre>object({<br/>    redrivePermission = string<br/>    sourceQueueArns   = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_service_source_arns"></a> [service\_source\_arns](#input\_service\_source\_arns) | Map of service names to source ARNs for condition checking | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_use_sqs_managed_sse"></a> [use\_sqs\_managed\_sse](#input\_use\_sqs\_managed\_sse) | Use SQS-managed server-side encryption (SSE-SQS) instead of KMS | `bool` | `false` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | Visibility timeout in seconds (0-43200) | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_age_of_oldest_message_arn"></a> [alarm\_age\_of\_oldest\_message\_arn](#output\_alarm\_age\_of\_oldest\_message\_arn) | ARN of the age of oldest message alarm |
| <a name="output_alarm_dlq_messages_arn"></a> [alarm\_dlq\_messages\_arn](#output\_alarm\_dlq\_messages\_arn) | ARN of the DLQ messages alarm |
| <a name="output_alarm_empty_receives_arn"></a> [alarm\_empty\_receives\_arn](#output\_alarm\_empty\_receives\_arn) | ARN of the empty receives alarm |
| <a name="output_alarm_messages_sent_arn"></a> [alarm\_messages\_sent\_arn](#output\_alarm\_messages\_sent\_arn) | ARN of the messages sent alarm |
| <a name="output_alarm_messages_visible_arn"></a> [alarm\_messages\_visible\_arn](#output\_alarm\_messages\_visible\_arn) | ARN of the messages visible alarm |
| <a name="output_cloudwatch_dashboard_arn"></a> [cloudwatch\_dashboard\_arn](#output\_cloudwatch\_dashboard\_arn) | ARN of the CloudWatch dashboard |
| <a name="output_cloudwatch_dashboard_url"></a> [cloudwatch\_dashboard\_url](#output\_cloudwatch\_dashboard\_url) | URL to CloudWatch dashboard |
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Connection information for applications |
| <a name="output_consumer_policy_arn"></a> [consumer\_policy\_arn](#output\_consumer\_policy\_arn) | ARN of the IAM policy for consumers |
| <a name="output_consumer_policy_id"></a> [consumer\_policy\_id](#output\_consumer\_policy\_id) | ID of the IAM policy for consumers |
| <a name="output_consumer_policy_name"></a> [consumer\_policy\_name](#output\_consumer\_policy\_name) | Name of the IAM policy for consumers |
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | ARN of the Dead Letter Queue |
| <a name="output_dlq_console_url"></a> [dlq\_console\_url](#output\_dlq\_console\_url) | URL to DLQ in AWS Console |
| <a name="output_dlq_consumer_policy_arn"></a> [dlq\_consumer\_policy\_arn](#output\_dlq\_consumer\_policy\_arn) | ARN of the IAM policy for DLQ consumers |
| <a name="output_dlq_consumer_policy_id"></a> [dlq\_consumer\_policy\_id](#output\_dlq\_consumer\_policy\_id) | ID of the IAM policy for DLQ consumers |
| <a name="output_dlq_consumer_policy_name"></a> [dlq\_consumer\_policy\_name](#output\_dlq\_consumer\_policy\_name) | Name of the IAM policy for DLQ consumers |
| <a name="output_dlq_id"></a> [dlq\_id](#output\_dlq\_id) | URL of the Dead Letter Queue |
| <a name="output_dlq_name"></a> [dlq\_name](#output\_dlq\_name) | Name of the Dead Letter Queue |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | URL of the Dead Letter Queue |
| <a name="output_full_access_policy_arn"></a> [full\_access\_policy\_arn](#output\_full\_access\_policy\_arn) | ARN of the IAM policy for full access |
| <a name="output_full_access_policy_id"></a> [full\_access\_policy\_id](#output\_full\_access\_policy\_id) | ID of the IAM policy for full access |
| <a name="output_full_access_policy_name"></a> [full\_access\_policy\_name](#output\_full\_access\_policy\_name) | Name of the IAM policy for full access |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | Alias of the KMS key used for encryption |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | ID of the KMS key used for encryption |
| <a name="output_producer_policy_arn"></a> [producer\_policy\_arn](#output\_producer\_policy\_arn) | ARN of the IAM policy for producers |
| <a name="output_producer_policy_id"></a> [producer\_policy\_id](#output\_producer\_policy\_id) | ID of the IAM policy for producers |
| <a name="output_producer_policy_name"></a> [producer\_policy\_name](#output\_producer\_policy\_name) | Name of the IAM policy for producers |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | ARN of the SQS queue |
| <a name="output_queue_configuration"></a> [queue\_configuration](#output\_queue\_configuration) | Complete queue configuration for reference |
| <a name="output_queue_console_url"></a> [queue\_console\_url](#output\_queue\_console\_url) | URL to queue in AWS Console |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | URL of the SQS queue |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Name of the SQS queue |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | URL of the SQS queue (same as queue\_id) |
<!-- END_TF_DOCS -->