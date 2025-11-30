locals {
    
}

resource "aws_ecr_repository" "ecr_repo" {
    for_each = local.all_ecr_repo_map
    name = each.key 
}