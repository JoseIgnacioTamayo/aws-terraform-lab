# Used as UnitTesting, to validate AWS region limitation

run "ok_eu" {
  command = plan

  variables {
    aws_region = "eu-central-1"
  }

  expect_failures = [check.jumphost]

  assert {
    condition     = output.whoami.arn != ""
    error_message = "Allowed EU AWS region"
  }
}

run "ko_not_eu" {
  command = plan

  variables {
    aws_region = "us-west-2"
  }


  expect_failures = [var.aws_region]

  assert {
    condition     = output.whoami == null
    error_message = "Not allowed non-EU AWS region"
  }
}
