terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Proyecto  = "Bootcamperu"
      Ambiente  = var.ambiente
      ManagedBy = "terraform"
      Autor     = "Emilio Castro"
    }
  }
}

provider "random" {}
