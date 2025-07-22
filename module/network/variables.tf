variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_name" {
  type    = string
  default = "main_vpc"
}
variable "vpc_cdr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_public_availability_zone" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}

variable "public_subnet_name" {
  type    = string
  default = "public_subnet"
}

variable "private_subnet_name" {
  type    = string
  default = "private_subnet"
}


variable "private_subnet_availability_zone" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}


variable "internet_gateway" {
  type    = string
  default = "main-igw"
}
variable "nat-ip" {
  type    = string
  default = "nat-ip"
}
variable "nat_gateway" {
  type    = string
  default = "nat_gateway"
}
variable "public_route_table" {
  type    = string
  default = "public_route_table"
}
variable "private-route-table" {
  type    = string
  default = "private-route-table"
}