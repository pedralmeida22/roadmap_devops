output "bastion_public_ip" {
    description = "Bastion server public IP"
    value = aws_instance.bastion_server.public_ip
}

output "private_server_ip" {
    description = "Private server ip"
    value = aws_instance.private_server.private_ip
}

output "private_server_name" {
    description = "Private server name"
    value = aws_instance.private_server.tags["Name"]
}

output "bastion_server_name" {
    description = "Bastion server name"
    value = aws_instance.bastion_server.tags["Name"]
}
