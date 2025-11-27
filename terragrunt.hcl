


remote_state {
  backend = "s3"
  config = {
    bucket         = "aryon-terraform-state-bucket"
    key            = "main/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
  }
  generate = {
    path      = "generated_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
generate "generate_provider" {
  path      = "generated_provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region              = "eu-central-1"
  allowed_account_ids = ["027574771246"]
}
EOF
}

generate "generate_locals" {
  path      = "generated_locals.tf"
  if_exists = "overwrite"
  contents = <<EOF
locals {
    group = ${jsonencode(split("/",path_relative_to_include()))}
}
EOF
}