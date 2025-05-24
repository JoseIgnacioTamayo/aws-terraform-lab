output "random_id" {
  value = module.magic.random_id
}

output "random_string" {
  value = module.magic.random_string
  # postcondition not possible on outputs
  precondition {
    condition     = length(regexall("[!@#$%&*\\(\\)\\-_=+\\[\\]{}<>:\\?]+", module.magic.random_string)) > 0
    error_message = "String must have special characters"
  }
}

output "mirrored_random_id" {
  value = var.use_tfstate_mirror ? module.mirror[0].random_id : ""
}

output "k8s_nodes_ips" {
  value = module.inelastic_k8s_service.k8s_nodes_ips
}

output "etcd_nodes_ips" {
  value = module.inelastic_k8s_service.etcd_nodes_ips
}

output "jumphost_ip" {
  value     = module.inelastic_k8s_service.jumphost_ip
  sensitive = true
}

output "jumphost_user" {
  value = module.inelastic_k8s_service.jumphost_user
}

output "whoami" {
  value = {
    arn = data.aws_caller_identity.current.arn
    id  = data.aws_caller_identity.current.user_id
  }
}
