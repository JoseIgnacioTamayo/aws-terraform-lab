/*provider "aws" {
  profile = var.aws_cli_profile
  region  = var.s3_region
}*/

run "bad_terraform_state_path" {
  command = plan

  variables {
    terraform_state_path = ""
  }

  expect_failures = [var.terraform_state_path]
  assert {
    condition     = output.random_string == null
    error_message = "Expected failure of var.terraform_state_path"
  }
}


run "state_not_found" {
  command = plan

  variables {
    terraform_state_path = "foo"
  }
  expect_failures = [data.terraform_remote_state.s3]
  assert {
    condition     = output.random_string == "not_found"
    error_message = "Did not return expected value when remote state not found"
  }
}