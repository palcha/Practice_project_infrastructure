resource "aws_s3files_file_system" "main" {
  bucket   = var.bucket_arn
  role_arn = var.role_arn
}

resource "aws_security_group" "s3_files" {
  name        = "s3-files-sg"
  description = "Security group for s3 Files mount target"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow NFS access from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "s3-files-sg"
  }
}

resource "aws_s3files_mount_target" "main" {
  for_each = toset(var.private_subnet_ids)

  file_system_id = aws_s3files_file_system.main.id
  subnet_id      = each.value

  security_groups = [
    aws_security_group.s3_files.id
  ]
}

# resource "aws_s3files_mount_target" "main" {
#   file_system_id = aws_s3files_file_system.main.id
#   subnet_id      = var.subnet_id

#   security_groups = [
#     aws_security_group.s3_files.id
#   ]
# }