# Digital Ocean VPC using Terraform and Ansible
[![My Skills](https://skillicons.dev/icons?i=ansible)](https://skillicons.dev)

## Usage
1. [**Ubuntu/Debian**](#requirements)
2. [**Mac**]()

### Requirements

- Digital Ocean personal access token

- SSH public key `id_rsa.pub` at `~/.ssh/id_rsa.pub`

- `*.tfvars` file should look like this -
```terraform
do_token = "your digital ocean private access token"
```

### How to Run

- First, terraform apply
```terraform
terraform apply
```
- Save the output
```bash
terraform output -json > ansible/output.json
```
- Now to run the ansible playbooks, let's `cd` into the `ansible/` directory
```bash
cd ansible
```
 - Run this playbook to configure the NAT gateway
```bash
ansible-playbook nat_gateway.yaml
```
- Run this playbook to setup the app servers
```bash
ansible-playbook app_config.yaml
```

- Go back to the project root folder
```
cd ..
```
- To test the vpc you can run the `test-run.sh` script (inside the project root dir) which will curl the loadbalancer
```bash
chmod +x scripts/test-run.sh
./scripts/test-run.sh
```
- The output should demonstrate the Round Robin algorithm in action.

### Note
If you are on a Mac, chances are that the `sed` command works differently to the Linux version of `sed`

To avoid any issues, follow these steps to install `gnu-sed` in your command line.

```bash
brew install gsed
```
and add this to ~/.zshrc in your mac
```bash
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
```
