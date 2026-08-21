variable "vpc_id" {
  description = "VPC ID where the s3 Files mount target will be created"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the s3 bucket used by s3 Files"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN assumed by s3 Files to access the s3 bucket"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the s3 Files mount target"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

