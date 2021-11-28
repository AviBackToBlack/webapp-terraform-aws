output "bastion_profile_id" {
  value = aws_iam_instance_profile.bastion_profile.id
}

output "webserver_profile_id" {
  value = aws_iam_instance_profile.webserver_profile.id
}