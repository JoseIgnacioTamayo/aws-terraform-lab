terraform {
  required_version = "~>1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    git = {
      source  = "metio/git"
      version = "= 2025.1.3"
    }
  }

  # Using incomplete backend configuration
  backend "s3" {
  }
}
