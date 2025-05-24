# Debian 11 Bullseye
data "aws_ami" "debian11" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-11-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "vm-key"
  public_key = file(var.ssh_publickey_file)
}

# Only assign IAM Role to VMs if calling AWS with enough premissions
# SSO Role PowerUser does NOT have access to read/use IAM Roles or Instance Profiles
resource "aws_iam_instance_profile" "this" {
  count = var.enable_vm_iam_role ? 1 : 0

  name = "iks-vm-profile"
  role = var.vm_iam_role
}