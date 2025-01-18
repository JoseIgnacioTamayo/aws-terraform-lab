resource "random_id" "this" {
  byte_length = var.length

  keepers = {
    seed = var.seed
  }
}

resource "random_string" "this" {
  length = var.length

  keepers = {
    seed = var.seed
  }
}

resource "random_integer" "this" {
  min = 4
  max = var.length

  seed = var.seed
}

resource "random_pet" "this" {
  separator = ":_:"
  length    = random_integer.this.result
}

variable "length" {
  type    = number
  default = 16
}

variable "seed" {
  type = string
}

output "random_id" {
  value = random_id.this.b64_std
}

output "random_string" {
  value = random_string.this.result
}

output "random_pet" {
  value = random_pet.this.id
}