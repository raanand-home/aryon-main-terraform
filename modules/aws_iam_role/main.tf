data "aws_caller_identity" "current" {}
variable "max_session_duration" {
  default = 3600
  type    = number
}
resource "aws_iam_role" "this" {
  name                 = var.name != null ? var.name : "${join("-",var.group)}"
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.this.json
  max_session_duration = var.max_session_duration
}
locals {


  ec2_assume_policy = [{
    sid     = "ec2"
    actions = ["sts:AssumeRole"]
    principals = [{
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }]
    }
  ]
  assume_by_github = [for repo in var.assume_by_github : {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    sid     = "github${replace(split("/", repo["repo"])[1], "-", "")}"
    principals = [{
      type        = "Federated"
      identifiers = [repo["oidc_arn"]]
    }]
    "condition" = [{
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${repo["repo"]}:*"]
    }]

    }
  ]
  assume_by_aws_accounts = [for account in var.assume_by_aws_accounts : {
    actions = flatten(concat(["sts:AssumeRole"], (account.tag_session != null ? account.tag_session : false) ? ["sts:TagSession"] : []))
    sid     = "awsaccount${account.account_id}"
    principals = [{
      type        = "AWS"
      identifiers = ["arn:aws:iam::${account.account_id}:root"]
    }]
    condition = account.external_id == null ? [] : [{
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [account.external_id]
    }]
    }
  ]

  assume_by_aws_sessions_pre = [for i in var.assume_by_aws_sessions : merge(i, { account = split(":", i.role_arn)[4],
  role_name = split("/", i.role_arn)[length(split("/", i.role_arn)) - 1] })]
  assume_by_aws_accounts_config = [for i, item in local.assume_by_aws_sessions_pre : merge(item, { random = random_string.session_ids[i].result })]

  assume_by_aws_sessions = [for session in local.assume_by_aws_accounts_config : {
    actions = flatten(concat(["sts:AssumeRole"], (session.tag_session != null ? session.tag_session : false) ? ["sts:TagSession"] : []))
    sid     = "awsaccount${session.random}"
    principals = [{
      type        = "AWS"
      identifiers = ["arn:aws:sts::${session.account}:assumed-role/${session.role_name}/${session.session_name}"]
    }]
    condition = session.external_id == null ? [] : [{
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [session.external_id]
    }]
    }
  ]

  assume_by_google_service_account = [for account in var.assume_by_google_service_account : {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    sid     = "gcpsa"
    principals = [{
      type        = "Federated"
      identifiers = ["accounts.google.com"]

    }]
    condition = [{
      test     = "StringEquals"
      variable = "accounts.google.com:sub"
      values   = [account.unique_id]

    }]
    }
  ]



  statements = flatten(concat([
    var.assume_by_ec2 ? local.ec2_assume_policy : [],
    local.assume_by_github,
    local.assume_by_aws_accounts,
    local.assume_by_aws_sessions,
    local.assume_by_google_service_account,
  ]))
}


resource "random_string" "session_ids" {
  count   = length(local.assume_by_aws_sessions_pre)
  length  = 8
  special = false
  upper   = false
  numeric  = false
}
data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = { for x in local.statements : x["sid"] => x }
    content {
      sid       = statement.value["sid"]
      actions   = lookup(statement.value, "actions", null)
      resources = lookup(statement.value, "resources", null)
      dynamic "condition" {
        for_each = { for i in lookup(statement.value, "condition", []) : i["variable"] => i }
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
      dynamic "principals" {
        for_each = { for i in lookup(statement.value, "principals", []) : i["type"] => i }
        content {
          identifiers = principals.value["identifiers"]
          type        = principals.value["type"]
        }
      }
    }
  }
}

