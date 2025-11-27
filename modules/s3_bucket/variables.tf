variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = null
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption, null for AES256"
  type        = string
  default     = null
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days until noncurrent versions expire"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags for the bucket"
  type        = map(string)
  default     = {}
}
variable "group" {
  type = list(string)
  description = "resource group"
}
