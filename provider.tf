terraform {
  backend "s3" {
    bucket         = "196820083683-2025-terraform-tfstate"
    key            = "dev.tfvars"
    region         = "eu-central-1"
    dynamodb_table = "196820083683-2025-terraform-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"

}
