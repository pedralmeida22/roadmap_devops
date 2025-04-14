## nodejs-service-deployment
This project creates an AWS EC2 instance, installs nodejs and npm, and deploys nodejs app as a systemd service.

### Provision infrastructure - Terraform
Create an EC2 instance on AWS. You need to have AWS credentials in ~/.aws/credentials.

In the terraform directory:
```
terraform init
terraform apply
```

Do not forget to destroy the infrastrucute when no longer needed:
```
terraform init
```

### Configure server - Ansible

The inventory file is automatically filled by Terraform. We could also use a dynamic inventory plugin (aws_ec2 in this case) to fetch the ansible hosts.

To configure the server:
```
ansible-playbook playbook.yml -i inventory/inventory.yml --tags "server" -e "ansible_ssh_private_key_file=./../terraform/tr_rsa_key.pem"
```

### Manual Ansible application deployment

To deploy the nodejs application to the server:
```
ansible-playbook playbook.yml -i inventory/inventory.yml --tags "app" --ask-vault-pass -e "ansible_ssh_private_key_file=./../terraform/tr_rsa_key.pem"
```

The vault stores the github access token to download the application files. The token must have repository read permissions.

In a browser, access the EC2 instance public IP in port 80 to view your application running
```
http://<ec2_ip>:80
```

### Automate Deployment using GitHub Actions
A GitHub Action workflow will deploy the application to the server.