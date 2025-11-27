terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  name = var.name != null ? var.name : "aryon-${join("-",var.group)}"
}
variable "group" {
  type = list(string)
  description = "resource group"
}
resource "aws_dynamodb_table" "this" {
  name           = local.name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key
  table_class    = var.table_class

  # Attributes
  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      name = var.range_key
      type = var.range_key_type
    }
  }

  # PAY_PER_REQUEST has no read/write capacity


  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.ttl_enabled
  }

  point_in_time_recovery {
    enabled = var.pitr_enabled
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  tags = var.tags
}
