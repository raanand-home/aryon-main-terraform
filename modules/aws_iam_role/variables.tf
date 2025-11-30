variable "group" {
  type = list(string)
}
variable "name" {
  type    = string
  default = null
}


variable "assume_by_ec2" {
  type    = bool
  default = false
}


variable "assume_by_github" {
  type = list(object({
    oidc_arn = string
    repo     = string
  }))
  default = []
}

variable "assume_by_google_service_account" {
  default = []

  type = list(object({
    unique_id = string
  }))
}

variable "assume_by_aws_sessions" {
  default = []
  type = list(object({
    role_arn     = string
    external_id  = optional(string)
    tag_session  = optional(bool)
    session_name = string
  }))
}

variable "assume_by_aws_accounts" {
  type = list(object({
    account_id  = string
    external_id = optional(string)
    tag_session = optional(bool)
  }))
  default = []
}


variable "path" {
  default = ""
}