resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  iam_instance_profile = var.instance_profile_name

  user_data = <<-EOF
  #!/bin/bash
  set -e

  # Install s3 Files mount helper
  yum install -y amazon-efs-utils

  # Create mount directory
  mkdir -p /mnt/s3files

  # Add persistent mount
  echo "${var.s3_files_file_system_id}:/ /mnt/s3files s3files _netdev,nofail 0 0" >> /etc/fstab

  # Mount s3 Files
  mount -a
EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}