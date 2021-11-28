variable "aws_region" {
  type        = string
  description = "AWS Region"
  validation {
    condition     = length(var.aws_region) > 1
    error_message = "Please check AWS region variable."
  }
}

variable "project_name" {
  type        = string
  description = "Project Name"
  validation {
    condition     = can(regex("[a-z0-9][a-z0-9.-]+[a-z0-9]", var.project_name))
    error_message = "The project name must be at least 3 chars long, begin and end with a letter or number and contain only [a-z0-9.-]."
  }
}

variable "user_role" {
  type        = string
  description = "User role. Can be 'dev' or 'test'."
  validation {
    condition     = lower(var.user_role) == "dev" || lower(var.user_role) == "test"
    error_message = "The user role must be either dev or test."
  }
}

variable "key_pair" {
  type        = string
  description = "AWS Key Pair Name"
  validation {
    condition     = length(var.key_pair) > 1
    error_message = "Please check the AWS Key Pair Name."
  }
}

variable "owner_email" {
  type        = string
  description = "Owner Email"
  validation {
    condition     = can(regex(".+@.+\\..+", var.owner_email))
    error_message = "Please check the owner email."
  }
}

variable "vpc_cidr_block" {
  type        = string
  default     = "192.168.0.0/23"
  description = "VPC CIDR Block"
}

variable "vpc_public_subnet_cidr_block" {
  type        = string
  default     = "192.168.0.0/24"
  description = "Public Subnet CIDR Block"
}

variable "vpc_private_subnet_cidr_block" {
  type        = string
  default     = "192.168.1.0/24"
  description = "Private Subnet CIDR Block"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

variable "ec2_volume_size" {
  type        = number
  default     = "10"
  description = "EC2 volume size"
}