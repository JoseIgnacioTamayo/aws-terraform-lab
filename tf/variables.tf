variable "aws_account_id" {
  type        = string
  description = "AWS Account ID to deploy the resources to"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the resources to"
}

variable "aws_cli_profile" {
  type        = string
  description = "AWS Cli profile to use to interact with AWS"
}

variable "vpc" {
  type = object({
    cidr = string
    name = string
  })
  description = "VPC to deploy the resources in"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ssh_publickey_file" {
  type        = string
  description = "Public key to upload to AWS as a KeyPair. Use the private key to SSH to VMs"
}

variable "vm_iam_role" {
  type        = string
  description = "IAM Role to attach to VMs"
}

variable "entropy" {
  type        = string
  description = "Change this value to regenerate the randonmess"
  default     = "DoNotChange"
}

variable "use_mirror" {
  type        = bool
  default     = false
  description = "True to read as data the same TerraformState and expose additional outputs"
}


# Variables named just like the S3 Backend config
variable "bucket" {
  type        = string
  sensitive   = true
  description = "S3 Bucket name"
}

variable "region" {
  type        = string
  sensitive   = true
  description = "S3 Bucket Region"
}

variable "key" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Path in the S3 bucket to the TerraformState"
}

variable "profile" {
  type        = string
  sensitive   = true
  default     = ""
  description = "AWS Cli Profile used to operate remote TerraformState in the S3 Bucket"
}
