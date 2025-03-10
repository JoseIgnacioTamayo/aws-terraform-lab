
data "aws_availability_zones" "available" {}

locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 1)
  subnets         = cidrsubnets(var.vpc.cidr, 2, 2, 2, 2)
  public_subnets  = slice(local.subnets, 0, 1)
  private_subnets = slice(local.subnets, 2, 4)
  ipv6_prefixes   = [1, 2, 3, 4]
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name        = var.vpc.name
  cidr        = var.vpc.cidr
  enable_ipv6 = true

  azs = local.azs

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  public_subnet_ipv6_prefixes = slice(local.ipv6_prefixes,
    0,
  length(local.public_subnets))
  private_subnet_ipv6_prefixes = slice(local.ipv6_prefixes,
    length(local.public_subnets),
  length(local.public_subnets) + length(local.private_subnets))

  private_subnet_assign_ipv6_address_on_creation = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

module "inelastic_k8s_service" {
  source = "./modules/inelastic_k8s_service"

  k8s_nodes_subnet_id  = module.vpc.private_subnets[0]
  etcd_nodes_subnet_id = module.vpc.private_subnets[1]
  jumphost_subnet_id   = module.vpc.public_subnets[0]
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = module.vpc.vpc_cidr_block

  ssh_publickey_file = var.ssh_publickey_file

  vm_iam_role = var.vm_iam_role
}

module "magic" {
  source = "./modules/random"

  seed = var.entropy
}

module "mirror" {
  source = "./modules/mirror_random_id"

  count = var.use_tfstate_mirror ? 1 : 0

  providers = {
    aws = aws.tfstate_mirror
  }

  s3_bucket            = var.tfstate_mirror.s3_bucket
  s3_region            = var.tfstate_mirror.s3_region
  terraform_state_path = var.tfstate_mirror.tfstate_s3_path
  aws_cli_profile      = var.tfstate_mirror.s3_aws_cli_profile
}

resource "terraform_data" "tfstate_mirror" {
  input = var.use_tfstate_mirror

  lifecycle {
    precondition {
      condition     = var.use_tfstate_mirror ? var.tfstate_mirror != null : true
      error_message = "If use_tfstate_mirror is tru, the variable tfstate_mirror must be provided"
    }
  }
}

data "aws_s3_bucket" "this" {
  provider = aws.s3

  bucket = var.s3_bucket
}

resource "aws_s3_object" "crumble" {
  provider = aws.s3

  key     = "crumble.txt"
  bucket  = data.aws_s3_bucket.this.id
  content = module.magic.random_pet

  lifecycle {
    postcondition {
      condition     = self.storage_class == "STANDARD"
      error_message = "StorageClass is not STANDARD"
    }
  }
}
