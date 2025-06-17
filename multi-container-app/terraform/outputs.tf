output "server_public_ip" {
  description = "Server public IP"
  value       = aws_instance.server.public_ip
}

output "server_name" {
  description = "Bastion server name"
  value       = aws_instance.server.tags["Name"]
}
