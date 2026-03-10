terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "platform-lab-tfstate-jshims-dev"
    key          = "vpc/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
    encrypt      = true
    profile      = "jshims-dev"
  }
}

provider "aws" {
  region  = var.region
  profile = "jshims-dev"
}

module "vpc" {
  source       = "../../modules/vpc"
  region       = var.region
  project_name = var.project_name
}

module "eks" {
  source             = "../../modules/eks"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}
