variable "tags" {
  type    = map(string)
  default = {}
}
variable "s3_bucket" {
  type    = string
  default = "terraform-testing-s3"
}