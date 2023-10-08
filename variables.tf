variable "do_token" {
  description = "Digital Ocean personal access token"
  sensitive = true
}

variable "image" {
  default = "ubuntu-22-04-x64"
}

variable "region" {
  default = "sgp1"
}

variable "size" {
  default = "s-1vcpu-512mb-10gb"
}

variable "cidr_block" {
  default = "10.10.0.0/24"
}
