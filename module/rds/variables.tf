variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "private_subnet_id" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "myapp"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "5Y2xyVQO688"
}
variable "aws_db_subnet_group" {
  type    = string
  default = "rds-subnet-group"
}
variable "rds_aws_security_group" {
  type    = string
  default = "rds-sg"
}

variable "rds_db_instance_identifier" {
  type    = string
  default = "rds"
}
variable "rds_db_instance_engine" {
  type    = string
  default = "mysql"
}
variable "rds_db_instance_engine_version" {
  type    = string
  default = "8.0"
}
variable "rds_db_instance_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "rds_db_instance_allocated_storage" {
  type    = number
  default = 20
}
variable "rds_db_instance_storage_type" {
  type    = string
  default = "gp2"
}