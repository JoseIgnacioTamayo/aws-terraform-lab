variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use"
}

variable "aws_cli_profile" {
  type = string
}

variable "vpc" {
  type = object({
    cidr = string
    name = string
  })
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ssh_publickey_file" {
  type = string
}

variable "vm_iam_role" {
  type = string
}

variable "entropy" {
  type        = string
  description = "Change this value to regenerate the randonmess"
  default     = "DoNotChange"
}

# Variables named just like the S3 Backend config
variable "use_mirror" {
  type    = bool
  default = false
}


variable "bucket" {
  type      = string
  sensitive = true
  default   = ""
}

variable "region" {
  type      = string
  sensitive = true
  default   = ""
}

variable "key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "profile" {
  type      = string
  sensitive = true
  default   = ""
}
