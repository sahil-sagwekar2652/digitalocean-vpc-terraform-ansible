resource "digitalocean_firewall" "gateway" {
  name        = "gateway"
  droplet_ids = [digitalocean_droplet.gateway.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}

resource "digitalocean_firewall" "app" {
  name        = "app"
  droplet_ids = [digitalocean_droplet.app1.id, digitalocean_droplet.app2.id]

  #   inbound_rule {
  #     protocol = "tcp"
  #     port_range = "22"
  #     source_addresses = [digitalocean_droplet.gateway.ipv4_address]
  #   }

  #   inbound_rule {
  #     protocol = "tcp"
  #     port_range = "80"
  #     source_addresses = [digitalocean_loadbalancer.public.ip]
  #   }

  #   outbound_rule {
  #     protocol = "tcp"
  #     port_range = "1-65535"
  #     destination_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  #   }

  #   outbound_rule {
  #     protocol = "udp"
  #     port_range = "1-65535"
  #     destination_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  #   }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.sgp_vpc.ip_range]
  }

}
