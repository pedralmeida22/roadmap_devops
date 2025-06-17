terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79.0"
    }
  }

  required_version = ">= 1.11.4"
}

provider "aws" {
  region = "eu-west-1"
}
