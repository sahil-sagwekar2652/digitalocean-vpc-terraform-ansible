output "loadbalancer_ip" {
  value = digitalocean_loadbalancer.public.ip
}

output "gateway_ip" {
  value = digitalocean_droplet.gateway.ipv4_address
}
