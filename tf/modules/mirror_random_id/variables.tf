variable "terraform_state_path" {
  type      = string
  sensitive = true
}

variable "s3_bucket" {
  type      = string
  sensitive = true
}

variable "s3_region" {
  type      = string
  sensitive = true
}