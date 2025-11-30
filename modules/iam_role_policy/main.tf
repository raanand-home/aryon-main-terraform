locals {
  statements = flatten(concat(
    local.s3_write_statments,
    local.sns_publish_statments,
    local.s3_read_statments,
    local.sqs_read_statments,
    local.sqs_write_statments,
    local.kinesis_put_statments,
    local.rds_connect_statments,
    local.assume_role_arns_statements,
    local.additinal_statements,
    local.assume_client_role_statements,
    local.kinesis_read_statments,
    local.kinesis_firehose_put_statments,
    local.secretmanager_ro_secret_statments,
    local.dynamodb_rw_statments,
    local.s3_replication_statments,
    local.push_to_ecr_statemants,
    local.ecr_authorization_token_statements,
  ))
  assume_client_role_statements = var.assume_client_role ? [{
    Action   = ["sts:AssumeRole"],
    Effect   = "Allow",
    Resource = ["arn:aws:iam::*:role/DigRole*"]

  }] : []
  additinal_statements = [for x in var.statements : merge(x, { Effect = "Allow" })]
  s3_write_statments = flatten([for x in var.s3_write :
    concat([
      {

        Action   = ["s3:PutObject*"],
        Effect   = "Allow"
        Resource = [x.path == null ? "${x.arn}/*" : "${x.arn}/${x.path}"]
      }])])

  kinesis_read_statments = [for x in var.kinesis_read :
    {
      Action = [
        "kinesis:List*",
        "kinesis:Get*",
        "kinesis:Describe*",
        "kinesis:SubscribeToShard",
      ],
      Effect   = "Allow"
      Resource = [x.arn]
    }
  ]
  kinesis_firehose_put_statments = [for x in var.kinesis_firehose_put :
    {
      Action = [
        "firehose:DescribeDeliveryStream",
        "firehose:ListDeliveryStreams",
        "firehose:ListTagsForDeliveryStream",
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      Effect   = "Allow"
      Resource = [x.arn]
    }
  ]

  secretmanager_ro_secret_statments = [
    for x in var.secretmanager_ro_secret :
    {
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      Effect   = "Allow"
      Resource = [x.arn]
    }
  ]

  kinesis_put_statments = [for x in var.kinesis_put :
    {
      Action = ["kinesis:PutRecord",
      "kinesis:PutRecords"],
      Effect   = "Allow"
      Resource = [x.arn]
    }
  ]
  assume_role_arns_statements = [for arn in var.assume_role_arns :
    {
      Action   = ["sts:AssumeRole"],
      Effect   = "Allow"
      Resource = [arn]
  }]

  rds_connect_statments = [for x in var.rds_connect :
    {
      Action   = ["rds-db:connect"],
      Effect   = "Allow"
      Resource = ["arn:aws:rds-db:${x.aws_region}:${x.aws_account}:dbuser:${x.db_instance_resource_id}/${x.name}"]
    }

  ]
  sns_publish_statments = [for x in var.sns_publish :
    {

      Action   = ["sns:Publish", ],
      Effect   = "Allow"
      Resource = ["${x.arn}"]
    }
  ]
  sqs_read_statments = [for x in var.sqs_read :
    {

      Action   = ["sqs:ReceiveMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes", "sqs:DeleteMessage"],
      Effect   = "Allow"
      Resource = ["${x.arn}"]
    }
  ]
  sqs_write_statments = [for x in var.sqs_write :
    {

      Action   = ["sqs:GetQueueUrl", "sqs:SendMessage", "sqs:SendMessageBatch"],
      Effect   = "Allow"
      Resource = ["${x.arn}"]
    }
  ]
  dynamodb_rw_statments = [
    for x in var.dynamodb_table_rw :
    {

      Action = [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:UpdateTimeToLive",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:PartiQLUpdate",
        "dynamodb:Scan",
        "dynamodb:ListTagsOfResource",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:DescribeTable",
        "dynamodb:PartiQLInsert",
        "dynamodb:GetItem",
        "dynamodb:ExportTableToPointInTime",
        "dynamodb:UpdateTable",
        "dynamodb:PartiQLDelete"
      ],
      Effect   = "Allow"
      Resource = ["${x.arn}"]
    }
  ]
  s3_replication_statments = [for x in var.s3_replication :
    flatten(concat([
      {
        Action = ["s3:GetReplicationConfiguration",
        "s3:ListBucket"],
        Effect   = "Allow"
        Resource = ["${x.source.arn}"]
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging"],
        Effect   = "Allow"
        Resource = ["${x.source.arn}/*"]
        }, {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
        "s3:ObjectOwnerOverrideToBucketOwner"],
        Effect   = "Allow"
        Resource = ["${x.dest.arn}/*"]
      },
      {
        Action   = ["kms:Decrypt", "kms:Encrypt"],
        Effect   = "Allow"
        Resource = [x.source.kms_key.arn]
      },
      {
        Action   = ["kms:Decrypt", "kms:Encrypt"],
        Effect   = "Allow"
        Resource = [x.dest.kms_key.arn]
      },
  ]))]

  s3_read_statments = [for x in var.s3_read :
    flatten(concat([
      {
        Action   = ["s3:GetObject", ],
        Effect   = "Allow"
        Resource = [x.path == null ? "${x.arn}/*" : "${x.arn}/${x.path}"]
      }, ], x.allow_list != null && x.allow_list == true ? [{
        Action   = ["s3:ListBucket", ],
        Effect   = "Allow"
        Resource = [x.arn]
      }] : [],
    ))
  ]

  push_to_ecr_statemants = [for x in var.push_to_ecr: 
    {
      Effect   = "Allow"
        Action   = ["ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage"],
        Effect   = "Allow"
        Resource = [x.arn]
    }
  ]
  ecr_authorization_token_statements = length(var.push_to_ecr)==0?[]:[
     {
      Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"],
        Effect   = "Allow"
        Resource = ["*"]
    }
  ]  

  base_name = var.policy_name != null ? var.policy_name : join("-",var.group)
}


resource "random_string" "this" {
  lower   = true
  special = false
  upper   = false
  length  = 4
}


moved {
  from = aws_iam_policy.this[0]
  to   = aws_iam_policy.this
}

resource "aws_iam_policy" "this" {
  name = "${local.base_name}-policy-${random_string.this.result}"
  path = "/main_account_config/${local.base_name}/"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.statements
  })
}


resource "aws_iam_role_policy_attachment" "this" {
  count      = length(local.statements) == 0 ? 0 : length(local.roles_names)
  role       = local.roles_names[count.index]
  policy_arn = aws_iam_policy.this.arn
}
resource "aws_iam_user_policy_attachment" "this" {
  count      = length(local.statements) == 0 ? 0 : length(var.attach_to_users)
  user       = var.attach_to_users[count.index].name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy" "policies" {
  for_each = toset(var.attached_policies)
  name     = each.key
}
locals {
  roles_names_none_filtered = [for x in var.attach_to_roles : x.name]
  roles_names               = [for x in local.roles_names_none_filtered : x if x != []]
}
resource "aws_iam_role_policy_attachment" "policies" {
  for_each = { for x in setproduct(toset(local.roles_names), toset(var.attached_policies)) : "${x[0]}=${x[1]}" => { role_name = x[0], policy = x[1] } }
  role     = each.value["role_name"]

  policy_arn = data.aws_iam_policy.policies[each.value["policy"]].arn
}

resource "aws_iam_user_policy_attachment" "policies" {
  for_each = { for x in setproduct(toset(var.attach_to_users), toset(var.attached_policies)) : "${x[0]}=${x[1]}" => { user = x[0], policy = x[1] } }
  user     = each.value["user"].name

  policy_arn = data.aws_iam_policy.policies[each.value["policy"]].arn
}