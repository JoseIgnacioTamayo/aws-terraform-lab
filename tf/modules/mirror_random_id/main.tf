# https://developer.hashicorp.com/terraform/language/state/remote-state-data

data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket  = var.s3_bucket
    region  = var.s3_region
    profile = var.aws_cli_profile
    key     = var.terraform_state_path
  }
}