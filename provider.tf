terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version    = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-3"
  access_key = ""
  secret_key = ""
}