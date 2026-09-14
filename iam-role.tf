module "iam" {
  source = "palcha/iam/aws"
  version = "1.0.0"

  project_name = var.project_name

  s3_bucket_arn = module.s3.bucket_arn
}
