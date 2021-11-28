provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Region  = var.aws_region
      Role    = replace(var.user_role, "test", "qa") # The role can be either "dev" or "test" but the tag Role was requested as "qa/dev"
      Project = var.project_name
      Owner   = var.owner_email
    }
  }
}

terraform {
  required_version = "1.0.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.67.0"
    }
  }
# ---------------------------------------- Populate Variables Here ----------------------------------------
  backend "s3" {
    bucket  = "" # <- S3 Backend Bucket Name
    region  = "" # <- S3 Backend Region
    key     = "terraform.tfstate"
    encrypt = "true"
  }
# ---------------------------------------- Populate Variables Here ----------------------------------------
}

module "vpc" {
  source = "./modules/vpc"

  project_name                  = var.project_name
  vpc_cidr_block                = var.vpc_cidr_block
  vpc_public_subnet_cidr_block  = var.vpc_public_subnet_cidr_block
  vpc_private_subnet_cidr_block = var.vpc_private_subnet_cidr_block
}

module "s3" {
  source = "./modules/s3"

  project_name                  = var.project_name
  user_role                     = var.user_role
}

module "iam" {
  source = "./modules/iam"

  project_name                  = var.project_name
  user_role                     = var.user_role
  s3_bucket_name                = module.s3.s3_bucket_id

  depends_on                    = [module.s3]
}

module "ec2" {
  source = "./modules/ec2"

  aws_region                    = var.aws_region
  project_name                  = var.project_name
  user_role                     = var.user_role
  ec2_instance_type             = var.ec2_instance_type
  ec2_volume_size               = var.ec2_volume_size
  private_subnet_id             = module.vpc.private_subnet_id
  public_subnet_id              = module.vpc.public_subnet_id
  private_security_group_id     = module.vpc.private_security_group_id
  public_security_group_id      = module.vpc.public_security_group_id
  bastion_profile_id            = module.iam.bastion_profile_id
  webserver_profile_id          = module.iam.webserver_profile_id
  key_pair                      = var.key_pair

  depends_on                    = [module.vpc]
}
