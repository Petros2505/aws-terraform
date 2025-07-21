terraform {
  backend "s3" {
    bucket  = "terraform-bucket-tes"
    key     = "terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}