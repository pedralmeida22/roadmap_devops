resource "aws_security_group" "tr_sg" {
  name = "tr_sg"
}

resource "aws_vpc_security_group_egress_rule" "tr_sg_egress" {
  security_group_id = aws_security_group.tr_sg.id
  description = "Allow all egress traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "tr_sg_ingress_ssh" {
  security_group_id = aws_security_group.tr_sg.id
  description = "Allow ssh traffic"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "tr_sg_ingress_http" {
  security_group_id = aws_security_group.tr_sg.id
  description = "Allow http traffic"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_instance" "nodejs_instance" {
  ami           = "ami-00a929b66ed6e0de6"   # amazon linux
  instance_type = "t2.micro"
  key_name = aws_key_pair.tr_key.key_name
  vpc_security_group_ids = [aws_security_group.tr_sg.id]

  tags = {
    Name = var.instace_name
  }
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
