variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "s3_files_file_system_id" {
  description = "S3 Files file system ID to mount on EC2"
  type        = string
}

variable "s3_files_mount_target_id" {
  description = "S3 Files mount target ID"
  type        = string
}