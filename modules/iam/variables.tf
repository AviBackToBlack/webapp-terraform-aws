variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "user_role" {
  type        = string
  description = "User role. Can be 'dev' or 'test'."
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket Name"
}