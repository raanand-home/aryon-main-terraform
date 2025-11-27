variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
  default = null
}

variable "hash_key" {
  description = "Partition key"
  type        = string
}

variable "hash_key_type" {
  description = "Attribute type (S, N, B)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Sort key (optional)"
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Sort key type (S, N, B)"
  type        = string
  default     = "S"
}

variable "billing_mode" {
  description = "PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type    = number
  default = 5
}

variable "write_capacity" {
  type    = number
  default = 5
}

variable "table_class" {
  description = "STANDARD or STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"
}

variable "pitr_enabled" {
  description = "Point-in-time recovery"
  type        = bool
  default     = true
}

variable "ttl_enabled" {
  type        = bool
  default     = false
}

variable "ttl_attribute" {
  type    = string
  default = "ttl"
}

variable "stream_enabled" {
  type    = bool
  default = false
}

variable "stream_view_type" {
  type    = string
  default = "NEW_AND_OLD_IMAGES"
}

variable "kms_key_arn" {
  description = "Optional custom KMS key for encryption"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
