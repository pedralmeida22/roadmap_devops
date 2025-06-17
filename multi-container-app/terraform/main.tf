resource "aws_security_group" "server_sg" {
  name = "private_server_sg"
}

resource "aws_vpc_security_group_egress_rule" "server_sg_egress" {
  security_group_id = aws_security_group.server_sg.id
  description       = "Allow all egress traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_sg_ingress_ssh" {
  security_group_id = aws_security_group.server_sg.id
  description       = "Allow ssh traffic"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_sg_ingress_http" {
  security_group_id = aws_security_group.server_sg.id
  description       = "Allow http traffic"
  ip_protocol       = "tcp"
  from_port         = 5000
  to_port           = 5000
  cidr_ipv4         = "0.0.0.0/0"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tr_key" {
  key_name   = "tr_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "rsa_private_key" {
  filename        = "tr_rsa_key.pem"
  file_permission = "0600"
  content         = tls_private_key.rsa.private_key_pem
}

resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tr_key.key_name

  tags = {
    Name = "my-server"
  }
}
