resource "digitalocean_firewall" "gateway" {
  name        = "gateway"
  droplet_ids = [digitalocean_droplet.gateway.id]
  depends_on  = [digitalocean_droplet.gateway]

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
  depends_on  = [digitalocean_droplet.app1, digitalocean_droplet.app2]

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
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
