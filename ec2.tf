module "EC2" {
  source = "./modules/EC2"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  subnet_id             = module.network.private_subnet_ids[0]
  instance_profile_name = module.iam.instance_profile_name

  ami_id                   = var.ami_id
  instance_type            = var.instance_type
  s3_files_file_system_id  = module.s3_files.file_system_id
  s3_files_mount_target_id = module.s3_files.mount_target_ids.subnet_a
}
