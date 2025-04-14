## Terraform on AWS

This Terraform script deploys a public EC2 instance in the region's default VPC, associated with a security group only allowing SSH traffic and a new key to access it.

### Prerequisites
- Terraform CLI installed
- AWS CLI installed and setup AWS credentials

You can use the `aws configure` command to setup your credentials.


### Write configuration
The `main.tf` file contains the terraform, providers and resources blocks.

The `variables.tf` file contains variables used in Terraform.

The `outputs.tf` file contains output values to present useful information to the Terraform user.


### Initialize the directory
Initialize Terraform and download the required providers:
```
terraform init
```
This commmand also generates/updates the lock file.

### Execution plan
Check what changes Terraform will make:
```
terraform plan
```

### Create infrastructure
Deploy the infrastrucure:
```
terraform apply
```

This will also create a .pem file and output the EC2 instance ip.

### Access the instance
Use the generated .pem file to access the instance via SSH:
```
ssh -i tr_rsa_key.pem ec2-user@<ip>
```

### Tear down infrastructure
```
terraform destroy
```


In this project we are managing state locally. However, to follow best practices, we should be using HCP Terraform to keep our state secured and encrypted, and where teammates have access to it.
