provider "aws" {
  region  = "us-east-1"
}

run "setup" {
  module {
    source = "./tests/setup/"
  }

  variables {
    cidr           = "10.99.99.0/24"
    public_subnet  = "10.99.99.128/28"
    private_subnet = "10.99.99.0/28"
    az             = "us-east-1a"
  }
}

run "deploy" {

  variables {
    k8s_nodes_subnet_id  = run.setup.private_subnet_id
    etcd_nodes_subnet_id = run.setup.private_subnet_id
    jumphost_subnet_id   = run.setup.public_subnet_id
    vpc_id               = run.setup.vpc_id
    vpc_cidr             = run.setup.vpc_cidr
    ssh_publickey_file   = "./tests/id_rsa.pub"
    vm_iam_role          = "EC2robot"
  }

  assert {
    condition     = data.http.jumphost.status_code == 200
    error_message = "Jumphost not ready"
  }
}

