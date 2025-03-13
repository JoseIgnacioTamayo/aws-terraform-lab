variables {
  seed = "foobarfoobarfoobar"
}
run "set_length" {
  variables {
    length = 5
  }

  assert {
    condition     = length(output.random_string) == var.length
    error_message = "Output random_string not of the right length"
  }
  assert {
    condition     = length(output.random_id) > var.length
    error_message = "Output random_id not of the right length"
  }
  assert {
    condition     = length(split(var.pet_separator, output.random_pet)) == output.random_integer
    error_message = "Output random_pet not of the right length"
  }
  assert {
    condition     = output.random_integer >= 3 && output.random_integer <= 9
    error_message = "random_integer not in bounds"
  }
}

run "interger_upperbound" {
  variables {
    length = 9
  }

  assert {
    condition     = output.random_integer >= 3 && output.random_integer <= 9
    error_message = "random_integer not in bounds"
  }
}

run "interger_lowerbound" {
  variables {
    length = 2
  }
  assert {
    condition     = output.random_integer == 3
    error_message = "random_integer invalid"
  }
}