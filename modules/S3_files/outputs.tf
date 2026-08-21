output "file_system_id" {
  description = "ID of the S3 Files file system"
  value       = aws_S3files_file_system.main.id
}

output "mount_target_id" {
  description = "ID of the S3 Files mount target"
  value       = aws_S3files_mount_target.main.id
}