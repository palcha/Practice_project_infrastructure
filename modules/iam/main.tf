resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "s3_files_role" {
  name = "s3-files-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "Allows3FilesAssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "elasticfilesystem.amazonaws.com"
        }

        Action = "sts:AssumeRole"

        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }

          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3files:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:file-system/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_files_policy" {
  name = "s3-files-bucket-access"
  role = aws_iam_role.s3_files_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "s3BucketPermissions"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ]

        Resource = var.s3_bucket_arn

        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },

      {
        Sid    = "s3ObjectPermissions"
        Effect = "Allow"

        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject*",
          "s3:GetObject*",
          "s3:List*",
          "s3:PutObject*"
        ]

        Resource = "${var.s3_bucket_arn}/*"

        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },

      {
        Sid    = "EventBridgeManage"
        Effect = "Allow"

        Action = [
          "events:DeleteRule",
          "events:DisableRule",
          "events:EnableRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets"
        ]

        Resource = "arn:aws:events:*:*:rule/DO-NOT-DELETE-s3-Files*"

        Condition = {
          StringEquals = {
            "events:ManagedBy" = "elasticfilesystem.amazonaws.com"
          }
        }
      },

      {
        Sid    = "EventBridgeRead"
        Effect = "Allow"

        Action = [
          "events:DescribeRule",
          "events:ListRuleNamesByTarget",
          "events:ListRules",
          "events:ListTargetsByRule"
        ]

        Resource = "arn:aws:events:*:*:rule/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_files_client" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/Amazons3FilesClientFullAccess"
}