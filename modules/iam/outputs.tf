output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "S3_files_role_arn" {
  description = "ARN of the IAM role used by S3 Files"
  value       = aws_iam_role.S3_files_role.arn
}