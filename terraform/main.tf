provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source   = "./modules/networking"
  project  = var.project_name
  vpc_cidr = var.vpc_cidr
  azs      = data.aws_availability_zones.available.names
}

module "security" {
  source  = "./modules/security"
  project = var.project_name
  # Optionally pass tags:
  # tags = { Project = var.project_name }
}

module "compute" {
  source          = "./modules/compute"
  project         = var.project_name
  lambda_role_arn = module.security.lambda_role_arn
}