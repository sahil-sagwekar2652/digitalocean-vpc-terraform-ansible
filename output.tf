output "loadbalancer_ip" {
  value      = digitalocean_loadbalancer.public.ip
  depends_on = [digitalocean_loadbalancer.public]
}

output "vpc_cidr_block" {
  value = var.cidr_block
}

output "gateway" {
  value = {
    public_ip  = digitalocean_droplet.gateway.ipv4_address
    private_ip = digitalocean_droplet.gateway.ipv4_address_private
  }
}

output "app1" {
  value = {
    public_ip  = digitalocean_droplet.app1.ipv4_address
    private_ip = digitalocean_droplet.app1.ipv4_address_private
  }
}

output "app2" {
  value = {
    public_ip  = digitalocean_droplet.app2.ipv4_address
    private_ip = digitalocean_droplet.app2.ipv4_address_private
  }
}

resource "null_resource" "json_output" {
  depends_on = [digitalocean_droplet.app1, digitalocean_droplet.app2, digitalocean_droplet.gateway, digitalocean_loadbalancer.public]

  provisioner "local-exec" {
    working_dir = path.module
    command     = <<-EOT
	terraform output -json > ansible/output.json;
	EOT
  }
}
