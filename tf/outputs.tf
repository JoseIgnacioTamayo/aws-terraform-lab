output "random_id" {
  value = module.magic.random_id
}

output "random_pet" {
  value = module.magic.random_pet
}

output "mirrored_random_id" {
  value = var.use_tfstate_mirror ? module.mirror[0].random_id : ""
}

output "k8s_nodes_dns" {
  value = module.inelastic_k8s_service.k8s_nodes_dns
}

output "jumphost_ip" {
  value     = module.inelastic_k8s_service.jumphost_ip
  sensitive = true
}

output "whoami" {
  value = {
    arn = data.aws_caller_identity.current.arn
    id  = data.aws_caller_identity.current.user_id
  }
}
