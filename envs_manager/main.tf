module "env_info" {
  source = "../modules/s3_bucket"
  group = local.group
  bucket_name = "aryon-envs-bucket"
}
output "env_info_bucket" {
  value = module.env_info
}