## Dockerized-service

This goal of this if to practice dockerizing applications, setting up remote servers, implementing CI/CD workflows and secrets management.

### Node.js service
Simple Node.js service with two routes:
 - `/` - which simply returns "Hello, world!"
 - `/secret` - protected by Basic Auth

`.env` file with:
```
USERNAME=abc
PASSWORD=123
SECRET_MESSAGE="Your secret message"
```


### Test the service locally

Build docker image:
```
docker build -t nodejs-app .
```

Start the service:
```
docker run -d -p 3000:3000 nodejs-app
```

Access the node.js service:
```
http://localhost:3000
```


### Provision infrastructure - Terraform
Create an EC2 instance on AWS. You need to have AWS credentials in ~/.aws/credentials.

In the terraform directory:
```
terraform init
terraform apply
```

Do not forget to destroy the infrastructure when no longer needed:
```
terraform destroy
```


### Automate Deployment using GitHub Actions
The GitHub Action workflow will deploy the application to the server when a new push on the `main` branch changes the `app` directory.

Required secrets for the workflow:
- EC2_IP - remote server ip
- SSH_PRIVATE_KEY - your private SSH key to access the remote server
- DOCKERHUB_USER - your DockerHub username
- DOCKERHUB_TOKEN - your DockerHub access token (with read and write permissions)

**Deployment:**
1. Build the docker image
2. Push the docker image to Docker Hub
3. SSH to remote server:
   1. Install docker, if necessary
   2. Pull new docker image
   3. Start the service

Access the node.js service:
```
http://<server-ip>:3000
```
