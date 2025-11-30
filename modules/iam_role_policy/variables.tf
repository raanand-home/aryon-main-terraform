variable "policy_name" {
  default = null
}
variable "group" {
  type = list(string)
  
}
variable "attach_to_roles" {
  type    = list(object({ name = string, arn = string }))
  default = []
}
variable "attach_to_users" {
  type = list(object({ name = string }))
  default = []
}
variable "statements" {
  type    = list(object({ Action = list(string), Resource = list(string) }))
  default = []
}
variable "push_to_ecr" {
  type =list (object({arn=string}))
  default = []
}
variable "assume_client_role" {
  default = false
  type    = bool
}
variable "s3_read" {
  default = []
  type = list(object(
    {
      arn = string
      path       = optional(string)
      allow_list = optional(bool)
    }
  ))
}
variable "sqs_read" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}


variable "sqs_write" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}
variable "sns_publish" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}

variable "kinesis_put" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}

variable "kinesis_firehose_put" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}


variable "kinesis_read" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}
variable "s3_write" {
  default = []
  type = list(object(
    {
      arn = string

      path = optional(string)
    }
  ))
}
variable "s3_replication" {
  default = []
  type = list(object({
    source = object(
      {
        arn = string
        kms_key = object(
          {
            arn = string
          }
        )
    })
    dest = object(
      {
        arn = string
        kms_key = object(
          {
            arn = string
          }
        )
    })
    }
  ))
}
variable "dynamodb_table_rw" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}

variable "secretmanager_ro_secret" {
  default = []
  type = list(object(
    {
      arn = string
    }
  ))
}

variable "assume_role_arns" {
  type    = list(string)
  default = []
}
variable "rds_connect" {
  default = []
  type = list(object(
    {
      arn                     = string
      db_instance_id          = string
      db_instance_resource_id = string
      name                    = string
      aws_region              = string
      aws_account             = string
    }
  ))
}

variable "attached_policies" {
  default = []
}
