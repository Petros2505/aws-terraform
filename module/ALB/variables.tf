variable "tags" {
  type    = map(string)
  default = {}
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
  type    = string
  default = "ecs-alb"
}
variable "aws_lb_target_group" {
  type    = string
  default = "ecs-alb-tg"
}
variable "alb-sg" {
  type    = string
  default = "alb-sg"
}
variable "alb_health_check" {
  type = list(object({
    enabled             = bool
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    interval            = number
    path                = string
    matcher             = string
    port                = number
    protocol            = string
  }))
}

variable "alb_sg_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string) 
  }))
}

variable "alb_sg_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string) 
  }))
}