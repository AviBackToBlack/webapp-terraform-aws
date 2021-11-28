output "bastion_public_hostname" {
  value = aws_instance.bastion.public_dns
}

output "webserver_private_ip" {
  value = aws_instance.webserver.private_ip
}