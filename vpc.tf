resource "digitalocean_vpc" "sgp_vpc" {
  name     = "automated-vpc"
  region   = var.region
  ip_range = var.cidr_block
}

resource "digitalocean_droplet" "gateway" {
  image    = var.image
  name     = "gateway"
  region   = var.region
  size     = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.sgp_vpc.id
}

resource "digitalocean_droplet" "app1" {
  depends_on = [digitalocean_droplet.gateway]
  image      = var.image
  name       = "app1"
  region     = var.region
  size       = var.size
  ssh_keys   = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid   = digitalocean_vpc.sgp_vpc.id
}

resource "digitalocean_droplet" "app2" {
  depends_on = [digitalocean_droplet.gateway]
  image      = var.image
  name       = "app2"
  region     = var.region
  size       = var.size
  ssh_keys   = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid   = digitalocean_vpc.sgp_vpc.id

  provisioner "local-exec" {
    command = <<-EOT
	sed -i '/# BOF DO_VPC/,/# EOF DO_VPC/d' ~/.ssh/config
	cat <<EOF >temp_conf
	# BOF DO_VPC
	# Created on $(date)
	Host gateway
	  HostName ${digitalocean_droplet.gateway.ipv4_address}
	  User root

	Host app1
	  HostName ${digitalocean_droplet.app1.ipv4_address_private}
	  User root
	  ProxyCommand ssh -W %h:%p gateway

	Host app2
	  HostName ${digitalocean_droplet.app2.ipv4_address_private}
	  User root
	  ProxyCommand ssh -W %h:%p gateway
	# EOF DO_VPC
	EOF
	cat temp_conf >> ~/.ssh/config
	rm -rf temp_conf
	EOT
  }
}

resource "digitalocean_loadbalancer" "public" {
  name      = "loadbalancer"
  region    = var.region
  algorithm = "round_robin"
  vpc_uuid  = digitalocean_vpc.sgp_vpc.id

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  firewall {
    allow = ["cidr:0.0.0.0/0"]
  }

  droplet_ids = [digitalocean_droplet.app1.id, digitalocean_droplet.app2.id]
}
