run "invalid_seed" {
    command = plan
  variables {
    seed = "foobar"
  }
  expect_failures = [var.seed]
  assert {
    condition     = output.random_string == null
    error_message = "Seed length too short allowed"
  }
}

run "setup" {
  variables {
    seed = "foofoofoofoofoofoofoo"
  }

  assert {
    condition     = output.random_string != ""
    error_message = "Output random_string is empty"
  }
}

# Reset seed, values must have changed
run "update" {
  variables {
    seed = "barbarbarbarbarbar"
  }

  assert {
    condition     = output.random_string != run.setup.random_string
    error_message = "Output random_string did not change"
  }
  assert {
    condition     = output.random_integer != run.setup.random_integer
    error_message = "Output random_integer did not change"
  }
  assert {
    condition     = output.random_id != run.setup.random_id
    error_message = "Output random_id did not change"
  }
}