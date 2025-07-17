locals {
  region = "eu-west-3"
  tags = {
    Environment = local.workspace["environment"]
    Provisioner = "terraform"
  }
}
locals {
  env = {
    default = {}
    dev = {
      environment                      = "dev"
      cidr                             = "10.0.0.0/16"
      subnet_public_cidr               = "10.0.1.0/24"
      subnet_public_availability_zone  = ["eu-west-3a", ]
      private_subnet_availability_zone = ["eu-west-3a", "eu-west-3b"]
      private_subnet_cidr              = ["10.0.2.0/24", "10.0.3.0/24"]
      ecs_instance_ami =              "ami-0d1ff537c292bb272"
      ecs_instance_instance_type = "t2.micro"
      container_definitions_name = "nginx"
      container_definitions_iamge = "nginx:latest"
      container_definitions_memory = "512"
      container_definitions_containerPort = 80
      container_definitions_hostPort = 80
      ecs_service_nginx = "nginx"
      ecs_task_definition_family = "nginx"
      rds_db_instance_engine = "mysql"
      rds_db_instance_instance_class = "db.t3.micro"
      rds_db_instance_allocated_storage = 20
      db_password = "5Y2xyVQO688"
      db_username = "admin"
      db_name = "myapp"
      DB_HOST = "database-1.czqekkaee86m.eu-west-3.rds.amazonaws.com"
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}