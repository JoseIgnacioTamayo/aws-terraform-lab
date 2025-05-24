variable "k8s_nodes_subnet_id" {
  type = string
}

variable "etcd_nodes_subnet_id" {
  type = string
}

variable "jumphost_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "k8s_nodes_count" {
  type    = number
  default = 3
}

variable "etcd_nodes_count" {
  type    = number
  default = 3
}

variable "ssh_publickey_file" {
  type = string
}

variable "vm_iam_role" {
  type = string
}

variable "enable_vm_iam_role" {
  type    = bool
  default = false
}