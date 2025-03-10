variable "aws_account_id" {
  type        = string
  description = "AWS Account ID to deploy the resources to"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the resources to"
  validation {
    condition     = startswith(var.aws_region, "eu-")
    error_message = "Only EU regions are supported"
  }
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
  default     = "DoNotChangeUnlessYouChange"
}

variable "use_tfstate_mirror" {
  type        = bool
  default     = false
  description = "True to read the remote TerraformState and expose the random values"
}

variable "tfstate_mirror" {
  type = object({
    tfstate_s3_path    = string
    s3_region          = string
    s3_bucket          = string
    s3_aws_cli_profile = string
  })
  default     = null
  description = "Read as data the TerraformState and expose the random values"
}

variable "s3_bucket" {
  type        = string
  sensitive   = true
  description = "S3 Bucket name"
}

variable "s3_region" {
  type        = string
  sensitive   = true
  description = "S3 Bucket Region"
}
