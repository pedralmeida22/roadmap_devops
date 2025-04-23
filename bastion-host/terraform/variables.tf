variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/24"
  description = "The IPv4 CIDR block for the VPC"
}

variable "az" {
  type = string
  default = "us-east-1a"
  description = "Availability zone"
}

variable "private_subnet" {
  type = string
  default = "10.0.0.0/28"
  description = "IPv4 private subnet CIDR block"
}

variable "public_subnet" {
  type = string
  default = "10.0.0.16/28"
  description = "IPv4 public subnet CIDR block"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
  description = "Instance type"
}

variable "ami_id" {
  type = string
  default = "ami-0e449927258d45bc4"
  description = "AMI ID"
}
