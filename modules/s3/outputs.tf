output "bucket_name" {
  description = "Name of the s3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "ARN of the s3 bucket"
  value       = aws_s3_bucket.main.arn
}