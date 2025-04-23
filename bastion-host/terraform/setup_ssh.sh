#!/bin/bash

# Add include line if it does not exist. It must be at the top of the file to work
grep -qxF "Include ~/.ssh/bastion_config" ~/.ssh/config || echo "Include ~/.ssh/bastion_config" >> ~/.ssh/config

BASTION_IP=$(terraform output -raw bastion_public_ip)
PRIVATE_IP=$(terraform output -raw private_server_ip)
USER=ec2-user
KEY=~/Documents/roadmap/roadmap_devops/bastion-host/terraform/tr_rsa_key.pem # path to key

cat << EOF > ~/.ssh/bastion_config
Host bastion
    HostName ${BASTION_IP}
    User ${USER}
    IdentityFile ${KEY}

Host private-server
    HostName ${PRIVATE_IP}
    User ${USER}
    ProxyJump bastion
    IdentityFile ${KEY}
EOF

echo "SSH config written to ~/.ssh/bastion_config"
