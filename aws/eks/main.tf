terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "my_network" {
  source = "./modules/network"

  vpc_cidr         = var.vpc_cidr
  user_name        = var.user_name
  sub_cidr_public  = var.sub_cidr_public
  sub_cidr_private = var.sub_cidr_private
  availabilty_zone = var.availability_zone

}
