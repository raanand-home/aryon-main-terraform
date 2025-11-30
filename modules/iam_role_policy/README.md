<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_client_role"></a> [assume\_client\_role](#input\_assume\_client\_role) | n/a | `bool` | `false` | no |
| <a name="input_assume_role_arns"></a> [assume\_role\_arns](#input\_assume\_role\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_attach_to_roles"></a> [attach\_to\_roles](#input\_attach\_to\_roles) | n/a | `list(object({ name = string, arn = string }))` | `[]` | no |
| <a name="input_attach_to_users"></a> [attach\_to\_users](#input\_attach\_to\_users) | n/a | `list(object({ name = string }))` | n/a | yes |
| <a name="input_attached_policies"></a> [attached\_policies](#input\_attached\_policies) | n/a | `list` | `[]` | no |
| <a name="input_dynamodb_table_rw"></a> [dynamodb\_table\_rw](#input\_dynamodb\_table\_rw) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_kinesis_firehose_put"></a> [kinesis\_firehose\_put](#input\_kinesis\_firehose\_put) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_kinesis_put"></a> [kinesis\_put](#input\_kinesis\_put) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_kinesis_read"></a> [kinesis\_read](#input\_kinesis\_read) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_rds_connect"></a> [rds\_connect](#input\_rds\_connect) | n/a | <pre>list(object(<br>    {<br>      arn                     = string<br>      db_instance_id          = string<br>      db_instance_resource_id = string<br>      name                    = string<br>      aws_region              = string<br>      aws_account             = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | n/a | `any` | `null` | no |
| <a name="input_s3_read"></a> [s3\_read](#input\_s3\_read) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>      kms_key = object(<br>        {<br>          arn = string<br>        }<br>      )<br>      path       = optional(string)<br>      allow_list = optional(bool)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_s3_replication"></a> [s3\_replication](#input\_s3\_replication) | n/a | <pre>list(object({<br>    source = object(<br>      {<br>        arn = string<br>        kms_key = object(<br>          {<br>            arn = string<br>          }<br>        )<br>    })<br>    dest = object(<br>      {<br>        arn = string<br>        kms_key = object(<br>          {<br>            arn = string<br>          }<br>        )<br>    })<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_s3_write"></a> [s3\_write](#input\_s3\_write) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>      kms_key = object(<br>        {<br>          arn = string<br>        }<br>      )<br>      path = optional(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_secretmanager_ro_secret"></a> [secretmanager\_ro\_secret](#input\_secretmanager\_ro\_secret) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_sns_publish"></a> [sns\_publish](#input\_sns\_publish) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_sqs_read"></a> [sqs\_read](#input\_sqs\_read) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_sqs_write"></a> [sqs\_write](#input\_sqs\_write) | n/a | <pre>list(object(<br>    {<br>      arn = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_statements"></a> [statements](#input\_statements) | n/a | `list(object({ Action = list(string), Resource = list(string) }))` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->