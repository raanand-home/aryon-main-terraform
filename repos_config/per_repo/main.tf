resource "random_string" "name" {
  length = 4
}
variable "name" {
  
}
variable "url" {
  
}
variable "push_to_ecrs" {
  type = list(object({arn=string}))

}
variable "is_terraform" {
  type    = bool
}
variable "group" {
  type = list(string)
}
variable "oidc_provider" {
  type = object({
    arn = string
    id = string
    url = string
  })
}

variable "terraform_dynamo_db_lock_table" {
  type = object({arn = string,name = string})
}
variable "terraform_bucket" {
  type = object({arn = string,bucket = string,id = string})
}
variable "code_artifects_bucket" {
  
}
module "iam_role" {
  source = "../../modules/aws_iam_role"
  group = var.group
  path = "/"
  assume_by_github = [{ repo = replace(var.url,"https://github.com/",""), oidc_arn = var.oidc_provider.arn }]
}
locals {
  s3_read = flatten(concat([merge(var.code_artifects_bucket,{allow_list=true})],var.is_terraform ? [var.terraform_bucket] : []))
  s3_write = flatten(concat([merge(var.code_artifects_bucket,{path = "${var.name}/"})],var.is_terraform ? [var.terraform_bucket] : []))
}


module "aws_policy" {
  source = "../../modules/iam_role_policy"
  group = var.group
  attach_to_roles = [module.iam_role]
  dynamodb_table_rw = var.is_terraform ? [var.terraform_dynamo_db_lock_table] : []
  s3_write = local.s3_write
  s3_read = local.s3_read
  push_to_ecr = var.push_to_ecrs

}
