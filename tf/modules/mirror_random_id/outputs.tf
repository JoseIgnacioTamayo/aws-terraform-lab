output "random_id" {
  value = try(
    data.terraform_remote_state.s3.outputs.random_id,
  "not_found")
}

output "random_string" {
  value = try(
    data.terraform_remote_state.s3.outputs.random_string,
  "not_found")
}