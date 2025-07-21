variable "tags" {
  type    = map(string)
  default = {}
}
variable "ecr_repository" {
  type    = string
  default = "ecr-repo"
}