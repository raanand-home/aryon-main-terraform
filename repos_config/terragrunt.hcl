include "root" {
  path = find_in_parent_folders()
}

dependency "github_oidc" {
  config_path = "../github_oidc"
}

dependency "terraform_resources" {
  config_path = "../terraform-resources"
}
inputs = {
  oidc_provider = dependency.github_oidc.outputs.oidc_provider
  terraform_dynamo_db_lock_table = dependency.terraform_resources.outputs.lock_table
  terraform_bucket = dependency.terraform_resources.outputs.bucket
}