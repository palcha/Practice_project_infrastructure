module "s3_files" {
  source = "palcha/s3files/aws"
  version = "1.0.0"

  bucket_arn = module.s3.bucket_arn
  role_arn   = module.iam.s3_files_role_arn

  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  #subnet_id = module.network.private_subnet_ids[0]
}
