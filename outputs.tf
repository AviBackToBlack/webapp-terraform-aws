output "bastion_public_hostname" {
  value       = module.ec2.bastion_public_hostname
  description = "The Bastion server public hostname"
}

output "webserver_private_ip" {
  value       = module.ec2.webserver_private_ip
  description = "The Webserver private ip address"
}

output "s3_bucket_name" {
  value       = module.s3.s3_bucket_id
  description = "S3 bucket name"
}
