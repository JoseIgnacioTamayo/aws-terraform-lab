output "k8s_nodes_dns" {
  value = aws_instance.k8s[*].private_dns
}

output "jumphost_ip" {
  value = aws_instance.jumphost.public_ip
}

output "jumphost_user" {
  value = "admin"
}