# Digital Ocean VPC using Terraform and Ansible


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
terraform output -json ansible/output.json
```
- Now to run the ansible playbooks, let's `cd` into the `ansible/` directory
```bash
cd ansible
```
 - Run this playbook to configure the NAT gateway
```bash
ansible-playbook -i hosts.yaml -e "@output.json" nat_gateway.yaml
```
- Run this playbook to setup the app servers
```bash
ansible-playbook -i hosts.yaml -e "@output.json" app_config.yaml
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
