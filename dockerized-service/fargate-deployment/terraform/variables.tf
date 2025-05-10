variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/24"
  description = "The IPv4 CIDR block for the VPC"
}

variable "az1" {
  type = string
  default = "us-east-1a"
  description = "Availability zone 1"
}

variable "az2" {
  type = string
  default = "us-east-1b"
  description = "Availability zone 2"
}

variable "public_subnet1" {
  type = string
  default = "10.0.0.0/28"
  description = "IPv4 public subnet CIDR block"
}

variable "public_subnet2" {
  type = string
  default = "10.0.0.16/28"
  description = "IPv4 public subnet CIDR block"
}

variable "docker_image" {
  type = string
  default = "nginx"
  description = "Docker image name"
}
