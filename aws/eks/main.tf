terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}

module "my_network" {
  source = "./modules/network"

  vpc_cidr  = var.vpc_cidr
  user_name = var.user_name
}
