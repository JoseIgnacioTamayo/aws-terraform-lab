resource "aws_instance" "jumphost" {

  subnet_id = var.jumphost_subnet_id

  associate_public_ip_address = true

  key_name = aws_key_pair.this.key_name

  tags = {
    Name = "jumphost"
  }

  ami = data.aws_ami.debian12.image_id

  instance_market_options {
    market_type = "spot"
  }

  # t2.nano is not supported for Spot
  instance_type = "t2.micro"

  monitoring = false

  vpc_security_group_ids = [aws_security_group.jumphost.id]

  user_data                   = filebase64("${path.module}/jumphost_boot.sh")
  user_data_replace_on_change = true # Because of Spot, VM needs to be recreated

}

data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  icanhazip = chomp(data.http.my_public_ip.response_body)
}

resource "aws_security_group" "jumphost" {
  name   = "jumphost" # cannot begin with sg-
  vpc_id = var.vpc_id

  ingress = [
    {
      protocol         = "tcp"
      to_port          = 22
      from_port        = 22
      description      = "SSH"
      cidr_blocks      = ["${local.icanhazip}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      protocol         = "tcp"
      to_port          = 8080
      from_port        = 8080
      description      = "HTTP"
      cidr_blocks      = ["${local.icanhazip}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      protocol         = "tcp"
      to_port          = 80
      from_port        = 80
      description      = "All_HTTP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      protocol         = "tcp"
      to_port          = 443
      from_port        = 443
      description      = "All_HTTPS"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      protocol         = "tcp"
      to_port          = 22
      from_port        = 22
      description      = "SSH"
      cidr_blocks      = [var.vpc_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "jumphost"
  }
}

# Checking the Jumphost is UP via Postcondition

data "http" "jumphost" {
  url    = "http://${aws_instance.jumphost.public_dns}:8080/index.html"
  method = "GET"

  retry {
    attempts = 3
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Jumphost ${aws_instance.jumphost.public_dns} is not ready"
    }
  }
}