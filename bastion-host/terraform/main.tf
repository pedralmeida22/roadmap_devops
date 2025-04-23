module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "bastion-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.az]
  private_subnets = [var.private_subnet]
  public_subnets  = [var.public_subnet]

  create_igw = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion_sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  description = "Allow all egress traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_sg_ingress" {
  security_group_id = aws_security_group.bastion_sg.id
  description = "Allow ssh traffic"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "private_server_sg" {
  name = "private_server_sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "private_server_sg_egress" {
  security_group_id = aws_security_group.private_server_sg.id
  description = "Allow all egress traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "private_server_sg_ingress" {
  security_group_id = aws_security_group.private_server_sg.id
  description = "Allow ssh traffic"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  referenced_security_group_id = aws_security_group.bastion_sg.id   # only allow traffic from bastion security group
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "tr_key" {
  key_name   = "tr_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "rsa_private_key" {
  filename = "tr_rsa_key.pem"
  file_permission = "0600"
  content = tls_private_key.rsa.private_key_pem
}

resource "aws_instance" "bastion_server" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.tr_key.key_name

  tags = {
    Name = "bastion-server"
  }
}

resource "aws_instance" "private_server" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.private_server_sg.id]
  associate_public_ip_address = false
  key_name = aws_key_pair.tr_key.key_name

  tags = {
    Name = "private-server"
  }
}
