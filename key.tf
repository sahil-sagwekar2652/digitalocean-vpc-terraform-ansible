resource "digitalocean_ssh_key" "default" {
  name       = "default-terraform"
  public_key = file("~/.ssh/id_rsa.pub")
}