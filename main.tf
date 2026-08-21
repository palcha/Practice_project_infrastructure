#provider block installprovider plugin:
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
#Instruction to connect to AWS Provider connect to AWS Config as per region:
provider "aws" {
  region = var.aws_region
}


module "network" {
  source = "./modules/network"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name




  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

  az1 = var.az1
  az2 = var.az2
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name

  s3_bucket_arn = module.s3.bucket_arn
}

module "s3_files" {
  source = "./modules/s3_files"

  bucket_arn = module.s3.bucket_arn
  role_arn   = module.iam.s3_files_role_arn

  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr

  subnet_id = module.network.private_subnet_ids[0]
}

module "EC2" {
  source = "./modules/EC2"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  subnet_id             = module.network.private_subnet_ids[0]
  instance_profile_name = module.iam.instance_profile_name

  ami_id                   = var.ami_id
  instance_type            = var.instance_type
  s3_files_file_system_id  = module.s3_files.file_system_id
  s3_files_mount_target_id = module.s3_files.mount_target_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name  = var.bucket_name
  project_name = var.project_name
}

#Resource block for VPC creation:
#resource "aws_vpc" "main" {
# cidr_block           = var.vpc_cidr
#enable_dns_support   = true
# enable_dns_hostnames = true

# tags = {
#  Name = "${var.project_name}-vpc"
# }
#}
#Subnet creation block:
#resource "aws_subnet" "public_a" {
# vpc_id                  = aws_vpc.main.id
#cidr_block              = var.public_subnet_1_cidr
#availability_zone       = var.az1
#map_public_ip_on_launch = true

#tags = {
# Name                                            = "${var.project_name}-public-a"
#"kubernetes.io/role/elb"                        = "1"
#"kubernetes.io/cluster/${var.project_name}-eks" = "shared"
#}

#}
#Subnet creation block:
#resource "aws_subnet" "public_b" {
# vpc_id                  = aws_vpc.main.id
#cidr_block              = var.public_subnet_2_cidr
#availability_zone       = var.az2
#map_public_ip_on_launch = true

#tags = {
# Name                                            = "${var.project_name}-public-b"
#"kubernetes.io/role/elb"                        = "1"
#"kubernetes.io/cluster/${var.project_name}-eks" = "shared"
#}

#}
#Internet Gateway block:
#resource "aws_internet_gateway" "igw" {
# vpc_id = aws_vpc.main.id

#tags = {
# Name = "main-igw"
#}
#}
#Elastic IP:
#resource "aws_eip" "nat" {
# domain = "vpc"

#tags = {
# Name = "${var.project_name}-nat-eip"
#}
#}
#NAT Gateway:
#resource "aws_nat_gateway" "main" {
# allocation_id = aws_eip.nat.id
#subnet_id     = aws_subnet.public_a.id

#depends_on = [
# aws_internet_gateway.igw
#]

#tags = {
# Name = "${var.project_name}-nat"
#}
#}

#Route Table block:
#resource "aws_route_table" "public_rt" {
# vpc_id = aws_vpc.main.id

#route {
# cidr_block = "0.0.0.0/0"
#gateway_id = aws_internet_gateway.igw.id
#}

#tags = {
# Name = "${var.project_name}-public-rt"
#}
#}
#Route Table Association with subnet:
#resource "aws_route_table_association" "public_a" {
# subnet_id      = aws_subnet.public_a.id
#route_table_id = aws_route_table.public_rt.id
#}

#resource "aws_route_table_association" "public_b" {
# subnet_id      = aws_subnet.public_b.id
#route_table_id = aws_route_table.public_rt.id
#}

#Adding Private Subnet:
#resource "aws_subnet" "private_a" {
# vpc_id            = aws_vpc.main.id
#cidr_block        = var.private_subnet_1_cidr
#availability_zone = var.az1

#tags = {
# Name                                            = "${var.project_name}-private-a"
#"kubernetes.io/role/internal-elb"               = "1"
#"kubernetes.io/cluster/${var.project_name}-eks" = "shared"
#}

#}
#Adding Private Subnet:
#resource "aws_subnet" "private_b" {
# vpc_id            = aws_vpc.main.id
#cidr_block        = var.private_subnet_2_cidr
#availability_zone = var.az2

#tags = {
# Name                                            = "${var.project_name}-private-b"
#"kubernetes.io/role/internal-elb"               = "1"
#"kubernetes.io/cluster/${var.project_name}-eks" = "shared"
#}

#}
#Creating Private Route Table:
#resource "aws_route_table" "private_rt" {
# vpc_id = aws_vpc.main.id

#route {
# cidr_block     = "0.0.0.0/0"
#nat_gateway_id = aws_nat_gateway.main.id
#}

#tags = {
# Name = "${var.project_name}-private-rt"
#}
#}
#Private subnet association with route table:
#resource "aws_route_table_association" "private_a" {
# subnet_id      = aws_subnet.private_a.id
#route_table_id = aws_route_table.private_rt.id
#}
#Private subnet association with route table:
#resource "aws_route_table_association" "private_b" {
# subnet_id      = aws_subnet.private_b.id
#route_table_id = aws_route_table.private_rt.id
#}

#EKS AMI Role:
#resource "aws_iam_role" "eks_cluster_role" {
# name = "${var.project_name}-eks-cluster-role"

#assume_role_policy = jsonencode({
# Version = "2012-10-17"

#Statement = [{
# Effect = "Allow"

#Principal = {
# Service = "eks.amazonaws.com"
#}

#Action = "sts:AssumeRole"
#}]
#})
#}
#EKS AMI Policy:
#resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
# role       = aws_iam_role.eks_cluster_role.name
#policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#}

#EKS Worker NODE ROLE CREATION:
#resource "aws_iam_role" "eks_node_role" {
# name = "${var.project_name}-eks-node-role"

#assume_role_policy = jsonencode({
# Version = "2012-10-17"

#Statement = [{
# Effect = "Allow"

#Principal = {
# Service = "ec2.amazonaws.com"
#}

#Action = "sts:AssumeRole"
#}]
#})
#}
#policy attachment to worker node:
#resource "aws_iam_role_policy_attachment" "worker_node" {
# role       = aws_iam_role.eks_node_role.name
#policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#}
#policy attachment to cni:
#resource "aws_iam_role_policy_attachment" "cni" {
# role       = aws_iam_role.eks_node_role.name
#policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#}
#policy attachment to ECR:
#resource "aws_iam_role_policy_attachment" "ecr" {
# role       = aws_iam_role.eks_node_role.name
#policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#}


#EKS Cluster Creation:
#resource "aws_eks_cluster" "main" {
# name     = "${var.project_name}-eks"
#role_arn = aws_iam_role.eks_cluster_role.arn

#vpc_config {
# subnet_ids = [
#   aws_subnet.private_a.id,
#   aws_subnet.private_b.id
# ]
#subnet_ids = module.network.private_subnet_ids

#endpoint_private_access = true
#endpoint_public_access  = true
#}

#depends_on = [
# aws_iam_role_policy_attachment.eks_cluster_policy
#]
#enabled_cluster_log_types = [
# "api",
#"audit",
#"authenticator",
#"controllerManager",
#"scheduler"
#]

#tags = {
# Name = "${var.project_name}-eks"
#}
#}

#EKS Node Group Creation:
#resource "aws_eks_node_group" "main" {
# cluster_name    = aws_eks_cluster.main.name
#node_group_name = "${var.project_name}-nodegroup"

#node_role_arn = aws_iam_role.eks_node_role.arn

# subnet_ids = [
#   aws_subnet.private_a.id,
#   aws_subnet.private_b.id
# ]
#subnet_ids = module.network.private_subnet_ids

#scaling_config {
# desired_size = 2
#max_size     = 4
#min_size     = 2
#}

#instance_types = [
# var.eks_node_instance_type
#]

#capacity_type = "ON_DEMAND"

#depends_on = [
# aws_iam_role_policy_attachment.worker_node,
#aws_iam_role_policy_attachment.cni,
#aws_iam_role_policy_attachment.ecr,
#aws_nat_gateway.main
#]

#tags = {
# Name = "${var.project_name}-nodegroup"

#"kubernetes.io/cluster/${var.project_name}-eks" = "owned"
#}
#}