# AWS Terraform Professional Lab

This deploys:

 * A VPC with 1 Public Subnet, and 2 Private Subnets, all dual-IP-stack.
    * A NAT Gateway for Internet connectivity
 * A Debian Jumphost on the Public Subnet (SSH allowed in SGs)
 * A set of EC2 instances in each of the Private Subnets
    * One set is an ASG, the other are individual EC2s.
 * A bunch of random-generated values
 * A file in an S3 Bucket, where one of the random values is written
 * Optionally, a TF module that reads one of the random values from the State file and outuputs it.

### Pre-requisites

This needs a pre-existing S3 Bucket where the TF State of all environments is written.

### How to use

[HOWTO.md](./HOWTO.md)

## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | = 2025.1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |
| <a name="provider_aws.s3"></a> [aws.s3](#provider\_aws.s3) | 5.84.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 2025.1.3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_inelastic_k8s_service"></a> [inelastic\_k8s\_service](#module\_inelastic\_k8s\_service) | ./modules/inelastic_k8s_service | n/a |
| <a name="module_magic"></a> [magic](#module\_magic) | ./modules/random | n/a |
| <a name="module_mirror"></a> [mirror](#module\_mirror) | ./modules/mirror_random_id | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.17.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.crumble](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [terraform_data.tfstate_mirror](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_session_context.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [git_commit.head](https://registry.terraform.io/providers/metio/git/2025.1.3/docs/data-sources/commit) | data source |
| [git_repository.repo](https://registry.terraform.io/providers/metio/git/2025.1.3/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID to deploy the resources to | `string` | n/a | yes |
| <a name="input_aws_cli_profile"></a> [aws\_cli\_profile](#input\_aws\_cli\_profile) | AWS Cli profile to use to interact with AWS | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy the resources to | `string` | n/a | yes |
| <a name="input_entropy"></a> [entropy](#input\_entropy) | Change this value to regenerate the randonmess | `string` | `"DoNotChangeUnlessYouChange"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 Bucket name | `string` | n/a | yes |
| <a name="input_s3_region"></a> [s3\_region](#input\_s3\_region) | S3 Bucket Region | `string` | n/a | yes |
| <a name="input_ssh_publickey_file"></a> [ssh\_publickey\_file](#input\_ssh\_publickey\_file) | Public key to upload to AWS as a KeyPair. Use the private key to SSH to VMs | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_tfstate_mirror"></a> [tfstate\_mirror](#input\_tfstate\_mirror) | Read as data the TerraformState and expose the random values | <pre>object({<br>    tfstate_s3_path    = string<br>    s3_region          = string<br>    s3_bucket          = string<br>    s3_aws_cli_profile = string<br>  })</pre> | `null` | no |
| <a name="input_use_tfstate_mirror"></a> [use\_tfstate\_mirror](#input\_use\_tfstate\_mirror) | True to read the remote TerraformState and expose the random values | `bool` | `false` | no |
| <a name="input_vm_iam_role"></a> [vm\_iam\_role](#input\_vm\_iam\_role) | IAM Role to attach to VMs | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC to deploy the resources in | <pre>object({<br>    cidr = string<br>    name = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jumphost_ip"></a> [jumphost\_ip](#output\_jumphost\_ip) | n/a |
| <a name="output_k8s_nodes_dns"></a> [k8s\_nodes\_dns](#output\_k8s\_nodes\_dns) | n/a |
| <a name="output_mirrored_random_id"></a> [mirrored\_random\_id](#output\_mirrored\_random\_id) | n/a |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | n/a |
| <a name="output_random_string"></a> [random\_string](#output\_random\_string) | n/a |
| <a name="output_whoami"></a> [whoami](#output\_whoami) | n/a |
<!-- END_TF_DOCS -->