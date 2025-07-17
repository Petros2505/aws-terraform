variable "tags" {
  type        = map(string)
  default     = {}
}
variable "public_subnet_id" {
  type = string
}
variable "private_subnet_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "aws_lb" {
  type = string
  default = "ecs-alb"
}
variable "aws_lb_target_group" {
  type = string
  default = "ecs-alb-tg"
}
variable "alb-sg" {
  type = string
  default = "alb-sg"
}