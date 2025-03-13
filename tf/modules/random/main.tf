resource "random_id" "this" {
  byte_length = var.length

  keepers = {
    seed = var.seed
  }
}

resource "random_string" "this" {
  length  = var.length
  special = var.string_special

  keepers = {
    seed = var.seed
  }
}

resource "random_integer" "this" {
  min = 3
  max = (var.length % 6) + 3

  seed = var.seed

  keepers = {
    seed = var.seed
  }
}

resource "random_pet" "this" {
  separator = var.pet_separator
  length    = random_integer.this.result
}

variable "length" {
  type    = number
  default = 16
}

variable "string_special" {
  type    = bool
  default = true
}

variable "pet_separator" {
  type    = string
  default = "&"
}

variable "seed" {
  type = string
  validation {
    condition     = length(var.seed) > 16
    error_message = "The seed must be >16 characters length"
  }
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

output "random_integer" {
  value = random_integer.this.result
}