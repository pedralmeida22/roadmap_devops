## Multi-Container Application

This project creates a simple todo list API using the Flask framework and a MongoDB database.


### Build infrastructure

Terraform will provision a server on AWS ec2 instance with the apropriate security group and a key pair.

Inside de `terraform` directory:
````
terraform init
terraform plan
terraform apply
````

The terraform script will output the public IP of the server.
Add the IP to the ansible inventory file.


### Configure the server

The ansible playbook will confiure the server created in the previous step by installing docker and docker compose.

Inside de `ansible` directory:
````
ansible-playbook playbook.yml -i inventory/inv.yml --tags "docker"
````

To manually deploy the application:
````
ansible-playbook --skip-tags "docker" --ask-vault-pass --ask-become-pass playbook.yml -i inventory/inv.yml
````

The `secrets.yml` file contains:
 - dh_token: Docker Hub access token
 - dh_username: Docker Hub username
 - gh_token: GitHub access token


### CI/CD

Required secrets:
 - SSH private key
 - ansible vault password

The GitHub workflow will run the playbook to deploy/upgrade the application by downloading the `docker-compose.yml` file, pulling the docker images and starting new containers.


### API usage

Get all TODOs:
````
curl http://<ip>:80/todos
````

Add new TODO:
````
curl -X POST http://<ip>:80/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Buy milk", "done": false}'
````

Setting a TODO as completed:
````
curl -X PUT http://<ip>:80/todos/<todo_id> \
  -H "Content-Type: application/json"
````

Delete a TODO:
```
curl -X DELETE http://<ip>:80/todos/<todo_id> \
     -H "Content-Type: application/json"
```

Delete all TODOs:
```
curl -X DELETE http://<ip>:80/todos \
     -H "Content-Type: application/json"
```


### Tear down infrastructure
When no longer needed:
```
terraform destroy
```
