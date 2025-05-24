
resource "aws_launch_template" "k8s" {
  name = "iks-k8s"

  # The t2.small instance type does not support specifying CpuOptions
  # cpu_options {
  #  core_count       = 4
  #  threads_per_core = 2
  # }

  dynamic "iam_instance_profile" {
    for_each = var.enable_vm_iam_role ? [0] : []
    content {
      name = aws_iam_instance_profile.this[0].name
    }
  }

  image_id = data.aws_ami.debian11.image_id

  key_name = aws_key_pair.this.key_name

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.small"

  monitoring {
    enabled = false
  }

}

resource "aws_instance" "k8s" {
  count = var.k8s_nodes_count

  launch_template {
    name    = aws_launch_template.k8s.name
    version = "$Latest"
  }

  associate_public_ip_address = false
  subnet_id                   = var.k8s_nodes_subnet_id
  vpc_security_group_ids      = [aws_security_group.k8s.id]

  tags = {
    Name = "k8s"
  }
}

resource "aws_security_group" "k8s" {
  name   = "k8s"
  vpc_id = var.vpc_id

  tags = {
    Name = "k8s"
  }
}

resource "aws_vpc_security_group_ingress_rule" "k8s_ssh" {
  security_group_id = aws_security_group.k8s.id

  referenced_security_group_id = aws_security_group.jumphost.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "k8s_etcd" {
  security_group_id = aws_security_group.k8s.id
 
  referenced_security_group_id = aws_security_group.etcd.id
  from_port                    = 2379
  to_port                      = 2380
  ip_protocol                  = "tcp"
}
