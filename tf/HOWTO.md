# HOWTO

## Get AWS Credentials and CLI

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

 * Use `aws configure --profile <iam_user>` to setup the credentials `~/.aws/credentials` and config `~/.aws/config` for an IAM user.

   > This is recommended with short-lived credentials

 * Setup a new profile for an IAM Role in `~/.aws/config` (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html). Link it to an IAM User that can take the Role.

   > The IAM Role profile CANNOT be linked to an SSO-based User (`'NoneType' object has no attribute 'get_frozen_token'`).

### For SSO:

 1. Use `aws configure sso-session --profile <sso>` to setup the SSO values, from your IAM Identidy instance.
 1. Use `aws configure sso --profile <sso>` to use the SSO Session.   
 1. Then get a Token with `aws sso login --sso-session <session>` to login and get a token.

> Check the identity used with `aws sts get-caller-identity --profile <profile>`.

 ## Setup AWS Provider

 https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

 https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference

 Credentials can be provided by using the `AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY` (optionally `AWS_SESSION_TOKEN`) environment variables. 
 
 The Region can be set in HCL, using the `AWS_REGION` or `AWS_DEFAULT_REGION` environment variables, or per Profile.

 Set the Profile to use with `AWS_PROFILE`.
 
> Environment variables are not supported for assuming IAM roles. Must be done in the **provider** config or via a **profile**

> Instead of setting manually an IAM User or Role to use when calling AWS from TF, a dedicated profile is used.
> AwsCli default profile is attached to an IAM Rolle that can only Read in AWS.
> TF AWS Provider needs to use a *dedicated profile that allows changes to AWS*. Else, it will use the default AwsCli profile.

## Configure S3 Backend

https://developer.hashicorp.com/terraform/language/backend/s3#configuration

We use incomplete Backend configuration to pass the sensitive values, in a `backend.tfvars` file.

> If an IAM Role is defined statically, any user/role calling TF needs to be able to assume the Role
> Instead, a dedicated Profile for the TF state manager is used

## Prepare some SSH Keys.

Although we could use Terraform to also provision the RSA Key used for SSH to the EC2 instance, this will store the private key in plain text in the Terraform state file.

Then, just create locally the RSA Keys and pass to Terraform the path to the Public Key, to upload to AWS.

https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair


## Run Terraform, run

```
export TF_WORKSPACE="<environment>"
export TF_CLI_ARGS_PLAN="--input=false"
export TF_CLI_ARGS_APPLY="--input=false"
export TF_IN_AUTOMATION=1
terraform init --backend-config backend.tfvars
terraform plan --var-file ./envs/$TF_WORKSPACE/values.tfvars
```

## SSH to VMs

https://mistwire.com/ssh-agent-forwarding-in-aws/

Use SSH Agent forwarding to pass along the SSH private Key from your client via the Jumphost (do not copy the private key to the jumpthost)

1. Start an SSH Agent locally with `eval $(ssh-agent)`
1. Add your private SSH Key with `ssh-add <private_key_file>`
1. SSH with Agent forwarding to the Jumphost `ssh -A <user>@<jumphost>`
1. SSH from the Jumphost to the VMs with `ssh <user>@<vm>`

## Document

`terraform-docs markdown table --output-file README.md .`