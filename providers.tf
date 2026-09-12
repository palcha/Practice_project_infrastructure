terraform {
  cloud {
    organization = "flask-project-eu-north-1"

    workspaces {
      name = "flask-project-eu-north-1"
    }
  }
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
