variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "user_role" {
  type        = string
  description = "User role. Can be 'dev' or 'test'."
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ec2_volume_size" {
  type        = number
  description = "EC2 volume size"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet id"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet id"
}

variable "private_security_group_id" {
  type        = string
  description = "Private security group id"
}

variable "public_security_group_id" {
  type        = string
  description = "Public security group id"
}

variable "bastion_profile_id" {
  type        = string
  description = "Bastion profile id"
}

variable "webserver_profile_id" {
  type        = string
  description = "Webserver profile id"
}

variable "key_pair" {
  type        = string
  description = "Key pair name"
}

