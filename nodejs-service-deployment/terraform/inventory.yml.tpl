# file populated by Terraform

all:
  hosts:
    ${instance_name}:
      ansible_host: ${instance_ip}
