variable "vpc_id" {
  description = "VPC ID where the S3 Files mount target will be created"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket used by S3 Files"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN assumed by S3 Files to access the S3 bucket"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the S3 Files mount target"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

