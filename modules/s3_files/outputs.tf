output "file_system_id" {
  description = "ID of the s3 Files file system"
  value       = aws_s3files_file_system.main.id
}

# output "mount_target_id" {
#   description = "ID of the s3 Files mount target"
#   value       = aws_s3files_mount_target.main.id
# }

output "mount_target_ids" {
  description = "S3 Files mount target IDs"

  value = {
    for subnet_key, mount_target in aws_s3files_mount_target.main :
    subnet_key => mount_target.id
  }
}