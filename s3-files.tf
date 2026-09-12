module "s3_files" {
  source = "./modules/s3_files"

  bucket_arn = module.s3.bucket_arn
  role_arn   = module.iam.s3_files_role_arn

  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  #subnet_id = module.network.private_subnet_ids[0]
}
