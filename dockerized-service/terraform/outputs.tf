output "instance_id" {
    description = "ID of the EC2 instance"
    value = aws_instance.nodejs_instance.id
}

output "public_ip" {
    description = "Public IP of the EC2 instance"
    value = aws_instance.nodejs_instance.public_ip
}

output "instance_name" {
    description = "EC2 instance name"
    value = aws_instance.nodejs_instance.tags["Name"]
}

