variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR Block"
}

variable "vpc_public_subnet_cidr_block" {
  type        = string
  description = "Public Subnet CIDR Block"
}

variable "vpc_private_subnet_cidr_block" {
  type        = string
  description = "Private Subnet CIDR Block"
}