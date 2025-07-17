terraform {
  backend "s3" {
    bucket = "terraform-bucket-tes"
    key    = "terraform.tfstate"
    region = "eu-west-3"
    # dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}