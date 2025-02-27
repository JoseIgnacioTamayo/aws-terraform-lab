# Git Provider for Branch and Commit information
# https://matthiasguentert.net/azure-resource-tagging/

provider "git" {}

data "git_commit" "head" {
  directory = "${path.module}/.."
  revision  = "@"
}

data "git_repository" "repo" {
  directory = "${path.module}/.."
}

locals {
  git_tags = {
    git_commit_hash      = substr(data.git_commit.head.sha1, 0, 8)
    git_commit_timestamp = data.git_commit.head.author.timestamp
    git_ommit_author_    = data.git_commit.head.author.name
    git_branch           = data.git_repository.repo.branch
  }
}

provider "aws" {
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_cli_profile
  region              = var.aws_region

  default_tags {
    tags = merge(var.tags, local.git_tags)
  }
}

provider "aws" {
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_cli_profile
  region              = var.s3_region

  alias = "s3"

  default_tags {
    tags = merge(var.tags, local.git_tags)
  }
}

provider "aws" {
  allowed_account_ids = [var.aws_account_id]
  profile             = var.use_tfstate_mirror ? var.tfstate_mirror.s3_aws_cli_profile : var.aws_cli_profile
  region              = var.use_tfstate_mirror ? var.tfstate_mirror.s3_region : var.s3_region

  alias = "tfstate_mirror"
}