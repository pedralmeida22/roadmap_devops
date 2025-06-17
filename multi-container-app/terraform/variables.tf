variable "az" {
  type        = string
  default     = "eu-west-1"
  description = "Availability zone"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"
}

variable "ami_id" {
  type        = string
  default     = "ami-03d8b47244d950bbb" # Amazon Linux
  description = "AMI ID"
}
