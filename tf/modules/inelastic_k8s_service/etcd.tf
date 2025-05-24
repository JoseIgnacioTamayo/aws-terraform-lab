# 2 Templates are used, because of differences in passing Subnet and SG information
resource "aws_launch_template" "etcd" {
  name = "iks-etcd"

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

  image_id = data.aws_ami.debian12.image_id

  key_name = aws_key_pair.this.key_name

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.small"

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.etcd.id]
  }

}

resource "aws_autoscaling_group" "etcd" {

  name             = "etcd-1"
  max_size         = var.etcd_nodes_count
  min_size         = 1
  desired_capacity = var.etcd_nodes_count

  force_delete = true

  launch_template {
    name    = aws_launch_template.etcd.name
    version = "$Latest"
  }

  vpc_zone_identifier = [var.etcd_nodes_subnet_id]

  tag {
    key                 = "Name"
    value               = "etcd"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "etcd" {
  name   = "etcd"
  vpc_id = var.vpc_id

  tags = {
    Name = "etcd"
  }
}

resource "aws_vpc_security_group_ingress_rule" "etcd_ssh" {
  security_group_id = aws_security_group.etcd.id

  referenced_security_group_id = aws_security_group.jumphost.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "etcd_etcd" {
  security_group_id = aws_security_group.etcd.id

  referenced_security_group_id = aws_security_group.etcd.id
  from_port                    = 2379
  to_port                      = 2380
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "etcd_etcd" {
  security_group_id = aws_security_group.etcd.id

  referenced_security_group_id = aws_security_group.etcd.id
  from_port                    = 2379
  to_port                      = 2380
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "etcd_k8s" {
  security_group_id = aws_security_group.etcd.id

  referenced_security_group_id = aws_security_group.k8s.id
  from_port                    = 2379
  to_port                      = 2379
  ip_protocol                  = "tcp"
}

data "aws_instances" "etcd" {
  instance_tags = {
    Name = "etcd"
  }

  depends_on = [aws_autoscaling_group.etcd]
}

resource "aws_autoscaling_attachment" "etcd" {
  autoscaling_group_name = aws_autoscaling_group.etcd.id
  elb                    = aws_elb.etcd.id
}

resource "aws_elb" "etcd" {
  name = "etcd"

  listener {
    instance_port     = 2379
    instance_protocol = "tcp"
    lb_port           = 2379
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:2379"
    interval            = 30
  }

  subnets         = [var.etcd_nodes_subnet_id]
  security_groups = [aws_security_group.etcd.id]

  internal                  = true
  cross_zone_load_balancing = false
  connection_draining       = true

  tags = {
    Name = "etcd"
  }
}