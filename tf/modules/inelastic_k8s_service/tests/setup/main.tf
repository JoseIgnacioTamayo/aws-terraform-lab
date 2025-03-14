terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  # name        = var.vpc.name
  cidr = var.cidr

  azs = [var.az]

  public_subnets  = [var.public_subnet]
  private_subnets = [var.private_subnet]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

variable "cidr" {
  type = string
}

variable "public_subnet" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "az" {
  type = string
}

output "private_subnet_id" {
  value = module.vpc.private_subnets[0]
}

output "public_subnet_id" {
  value = module.vpc.public_subnets[0]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}