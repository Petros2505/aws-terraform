variable "tags" {
  type    = map(string)
  default = {}
}
variable "aws_ecs_cluster" {
  type    = string
  default = "ecs-cluster"
}
variable "ecs_instance_ami" {
  type    = string
  default = "ami-0d1ff537c292bb272"
}
variable "ecs_instance_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ecs_instance_subnet_id" {
  type = list(string)
}
variable "ecs_instances" {
  type    = string
  default = "ecs-instances"
}

variable "container_definitions_name" {
  type = string
}
variable "container_definitions_iamge" {
  type = string
}
variable "container_definitions_memory" {
  type = number
}
variable "container_definitions_containerPort" {
  type = number
}
variable "container_definitions_hostPort" {
  type = number
}
variable "ecs_service_nginx" {
  type = string
}
variable "ecs_task_definition_family" {
  type = string
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "ecs_autoscaling_group" {
  type    = string
  default = "ecs-asg"
}
variable "ecs_launch_template" {
  type    = string
  default = "ecs"
}
variable "ecs_instance_sg" {
  type    = string
  default = "ecs_instance_sg"
}
variable "ecs_instance_name" {
  type    = string
  default = "ecs-instance"
}

variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "DB_HOST" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "ecs_instance_role" {
  type = string
  default = "ecs_user_role"
}
variable "ecs_instance_profile" {
  type = string
  default = "ecs_user"
}

variable "ecs_instance_sg_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string) 
  }))
}

variable "ecs_instance_sg_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string) 
  }))
}