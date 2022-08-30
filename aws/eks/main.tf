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

module "my_compute" {
  source = "./modules/compute"

  depends_on = [
    module.my_network
  ]

  user_name      = var.user_name
  subnet_private = module.my_network.subnet_private
  subnet_public  = module.my_network.subnet_public
}

provider "helm" {
  kubernetes {

    config_path = "~/.kube/config"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  create_namespace = true
  namespace        = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

    depends_on = [
    module.my_compute
  ]

}
