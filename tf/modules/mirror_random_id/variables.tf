variable "terraform_state_path" {
  type      = string
  sensitive = true
  validation {
    condition     = var.terraform_state_path != "" && var.terraform_state_path != null
    error_message = "The path to the TerraformState cannot be empty"
  }
}

variable "s3_bucket" {
  type      = string
  sensitive = true
}

variable "s3_region" {
  type      = string
  sensitive = true
}

variable "aws_cli_profile" {
  type      = string
  sensitive = true
}