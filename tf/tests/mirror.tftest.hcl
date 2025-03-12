# Used as UnitTesting, to validate optional use of mirror module

variables {
  use_tfstate_mirror = true
}

run "no_mirror_no_output" {
  command = plan

  plan_options {
    target = [module.mirror, terraform_data.tfstate_mirror]
  }

  variables {
    use_tfstate_mirror = false
  }

  assert {
    condition     = output.mirrored_random_id == ""
    error_message = "Without Mirror, output is not empty"
  }

}


run "missing_input" {
  command = plan

  plan_options {
    target = [terraform_data.tfstate_mirror]
  }

  variables {
    tfstate_mirror = null
  }

  expect_failures = [terraform_data.tfstate_mirror]

  assert {
    condition     = output.mirrored_random_id == null
    error_message = "Expected failure of incomplete tfstate_mirror"
  }
}

run "yes_mirror_yes_output" {
  command = plan

  plan_options {
    target = [module.mirror, terraform_data.tfstate_mirror]
  }

  assert {
    condition     = output.mirrored_random_id == module.mirror[0].random_id
    error_message = "With Mirror, output is not as expected -${module.mirror[0].random_id}-"
  }
}

run "bad_remotestate_path" {
  command = plan

  plan_options {
    target = [module.mirror, terraform_data.tfstate_mirror]
  }

  variables {
    tfstate_mirror = {
      s3_aws_cli_profile = var.aws_cli_profile
      s3_bucket          = var.s3_bucket
      s3_region          = var.s3_region
      tfstate_s3_path    = "foo"
    }
  }

  expect_failures = [module.mirror[0].data.terraform_remote_state.s3]

  assert {
    condition     = output.mirrored_random_id == module.mirror[0].random_id
    error_message = "With Mirror, output is not as expected -${module.mirror[0].random_id}-"
  }
}