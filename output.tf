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

resource "terraform_data" "ssh_config" {
  depends_on = [digitalocean_droplet.gateway, digitalocean_droplet.app1, digitalocean_droplet.app2]

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

resource "terraform_data" "json_output" {
  depends_on = [digitalocean_droplet.app1, digitalocean_droplet.app2, digitalocean_droplet.gateway, digitalocean_loadbalancer.public]

  provisioner "local-exec" {
    working_dir = path.module
    command     = <<-EOT
	sleep 5
	terraform output -json > ansible/output.json;
	EOT
  }
}

resource "terraform_data" "destroy_time_provisioner" {
  provisioner "local-exec" {
    working_dir = path.module
    when        = destroy
    command     = <<-EOT
	sed -i '/# BOF DO_VPC/,/# EOF DO_VPC/d' ~/.ssh/config
	rm -rf ansible/output.json
	EOT
  }
}
