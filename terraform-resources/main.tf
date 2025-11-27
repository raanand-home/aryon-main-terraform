resource "random_string" "s" {
    length = 4
  
}
module bucket {
    source = "../modules/s3_bucket"
    group = local.group
    bucket_name = "aryon-terraform-state-bucket"
}

module lock_table {
    source = "../modules/dynamodb_table"
    group = local.group
    hash_key = "state"
}
output "bucket" {
  value = module.bucket
}
output "lock_table" {
  value = module.lock_table
}