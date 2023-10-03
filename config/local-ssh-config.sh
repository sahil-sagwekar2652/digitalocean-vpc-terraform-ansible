sed -i '/# BOF DO_VPC/,/# EOF DO_VPC/d' ~/.ssh/config
cat <<EOF >temp_conf
# BOF DO_VPC
# Created on $(date)
Host app1
  HostName ${digitalocean_droplet.app1.ipv4_address_private}
  User root
  ProxyCommand ssh -W %h:%p root@${digitalocean_droplet.gateway.ipv4_address}

Host app2
  HostName ${digitalocean_droplet.app2.ipv4_address_private}
  User root
  ProxyCommand ssh -W %h:%p root@${digitalocean_droplet.gateway.ipv4_address}
# EOF DO_VPC
EOF
cat temp_conf >> ~/.ssh/config
rm -rf temp_conf
