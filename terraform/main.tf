# 1. Yeh hai terraform block jo provider version constraint set karta hai
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Lock tools to AWS Provider version 5.x
    }
  }
}

# 2. AWS Provider block configuration
provider "aws" {
  region = var.aws_region
}

# 3. Required Data blocks (Only keeping the used one)
data "aws_availability_zones" "available" {
  state = "available"
}

# 4. Infrastructure Modules
module "networking" {
  source   = "./modules/networking"
  project  = var.project_name
  vpc_cidr = var.vpc_cidr
  azs      = data.aws_availability_zones.available.names
}

module "compute" {
  source          = "./modules/compute"
  project         = var.project_name
  lambda_role_arn = module.security.lambda_role_arn
}

module "security" {
  source             = "./modules/security"
  project            = var.project_name
  dynamodb_table_arn = module.compute.dynamodb_table_arn
}