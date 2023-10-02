resource "digitalocean_vpc" "sgp_vpc" {
  name     = "automated-vpc"
  region   = var.region
  ip_range = "10.0.0.0/24"
}

resource "digitalocean_droplet" "gateway" {
  image  = var.image
  name   = "gateway"
  region = var.region
  size   = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.sgp_vpc.id
  user_data = file("./config/gateway-config.yml")
}

resource "digitalocean_droplet" "app1" {
  image = var.image
  name   = "app1"
  region = var.region
  size   = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.sgp_vpc.id
  user_data = file("./config/app-config.yml")
}

resource "digitalocean_droplet" "app2" {
  image = var.image
  name   = "app2"
  region = var.region
  size   = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.sgp_vpc.id
  user_data = file("./config/app-config.yml")

  provisioner "local-exec" {
    command = file("./config/local-ssh-config.sh")
  }
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer"
  region = var.region
  algorithm = "round_robin"
  vpc_uuid = digitalocean_vpc.sgp_vpc.id

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  firewall {
    allow = ["cidr:0.0.0.0/0"]
  }

  droplet_ids = [digitalocean_droplet.app1.id, digitalocean_droplet.app2.id]
}