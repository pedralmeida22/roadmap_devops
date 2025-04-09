## Terraform on AWS

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

### Tear down infrastructure
```
terraform destroy
```


In this project we are managing state locally. However, to follow best practices, we should be using HCP Terraform to keep out state in a secure and encrypted, and where teammates have access to it.
