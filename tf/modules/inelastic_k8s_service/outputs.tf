output "k8s_nodes_dns" {
  value = aws_instance.k8s[*].private_dns
}

output "k8s_nodes_ips" {
  value = aws_instance.k8s[*].private_ip
}

output "etcd_nodes_ips" {
  value = data.aws_instances.etcd.private_ips
}

output "jumphost_ip" {
  value = aws_instance.jumphost.public_ip
}

output "jumphost_http_health" {
  value = "http://${aws_instance.jumphost.public_dns}:8080/health"
}

output "jumphost_user" {
  value = "admin"
}
