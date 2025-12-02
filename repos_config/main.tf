locals {
   repos_yaml = yamldecode(file("repos.yaml"))
   all_git_repos_list = local.repos_yaml["git_repos"]
   all_git_repos_list_enrich = [for x in local.repos_yaml["git_repos"]: merge(x,{
            name =replace( x["url"],"https://github.com/raanand-home/","")
            }
        )
    ]
   all_git_repos_map = { for x in local.all_git_repos_list_enrich:x["name"]=>x }
   
   all_ecr_repo_list = flatten([for git_repos in local.all_git_repos_list_enrich: lookup(git_repos,"ecr_repo",[])])
   all_ecr_repo_map = { for x in local.all_ecr_repo_list:x["name"]=>x }
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

module "per_git_repo" {
  for_each = local.all_git_repos_map
  source = "./per_repo"
  oidc_provider = var.oidc_provider
  name   = each.key
  url    = each.value["url"]
  is_terraform = lookup(each.value,"is_terraform",false)
  group  = concat(local.group,[each.key])
  terraform_bucket = var.terraform_bucket
  terraform_dynamo_db_lock_table = var.terraform_dynamo_db_lock_table
  push_to_ecrs = each.value["ecr_repo"] != null ? [for x in  each.value["ecr_repo"]:aws_ecr_repository.ecr_repo[x["name"]]] : []
  code_artifects_bucket = module.code_artifects
  attached_policies = lookup(each.value,"attached_policies",[])
}

module "code_artifects" {
  source = "../modules/s3_bucket"
  group = concat(local.group, ["code_artifacts"])
  bucket_name = "aryon-code-artifacts"
}