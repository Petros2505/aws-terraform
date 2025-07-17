module "vpc" {
  source = "./module/network"

  tags                             = local.tags
  vpc_name                         = "${local.workspace.environment}-${var.project_name}-vpc"
  vpc_cdr                          = local.workspace.cidr
  subnet_public_cidr               = local.workspace.subnet_public_cidr
  public_subnet_name               = "${local.workspace.environment}-${var.project_name}-public-subnet"
  private_subnet_availability_zone = local.workspace.private_subnet_availability_zone
  private_subnet_name              = "${local.workspace.environment}-${var.project_name}-private-subnet"
  internet_gateway                 = "${local.workspace.environment}-${var.project_name}-internet-gateway"
  nat_gateway                      = "${local.workspace.environment}-${var.project_name}-internet_gateway"
  public_route_table               = "${local.workspace.environment}-${var.project_name}-public_route_table"
  private-route-table              = "${local.workspace.environment}-${var.project_name}-private-route-table"
  nat-ip                           = "${local.workspace.environment}-${var.project_name}-nat-ip"
}

module "ecs" {
  source = "./module/ecs"
  tags = local.tags
  aws_ecs_cluster = "${local.workspace.environment}-${var.project_name}-ecs-cluster"
  ecs_instance_subnet_id = module.vpc.private_subnet_id
  ecs_instances = "${local.workspace.environment}-${var.project_name}-ecs-instances"
  ecs_instance_ami = local.workspace.ecs_instance_ami
  ecs_instance_instance_type = local.workspace.ecs_instance_instance_type
  container_definitions_name = local.workspace.container_definitions_name
  container_definitions_iamge = local.workspace.container_definitions_iamge
  container_definitions_memory = local.workspace.container_definitions_memory
  container_definitions_containerPort = local.workspace.container_definitions_containerPort
  container_definitions_hostPort = local.workspace.container_definitions_hostPort
  ecs_task_definition_family = local.workspace.ecs_task_definition_family
  ecs_service_nginx = local.workspace.ecs_service_nginx
  ecs_autoscaling_group = "${local.workspace.environment}-${var.project_name}-ecs-asg"
  ecs_launch_template = "${local.workspace.environment}-${var.project_name}-ecs-template"
  ecs_instance_sg = "${local.workspace.environment}-${var.project_name}-ecs-instance-sg"
  target_group_arn = module.ALB.target_group_arn
  ecs_instance_name = "${local.workspace.environment}-${var.project_name}-ecs-instance"
  vpc_id                = module.vpc.vpc_id
  db_name     = local.workspace.db_name
  db_username = local.workspace.db_username
  db_password = local.workspace.db_password
  DB_HOST = local.workspace.DB_HOST
  
}

module "rds" {
  source = "./module/rds"
  tags = local.tags
  vpc_id                = module.vpc.vpc_id
  private_subnet_id    = module.vpc.private_subnet_id
  db_password = local.workspace.db_password
  aws_db_subnet_group = "${local.workspace.environment}-${var.project_name}-rds-subnet-group"
  rds_aws_security_group = "${local.workspace.environment}-${var.project_name}-rds-sg"
  rds_db_instance_identifier = "${local.workspace.environment}-${var.project_name}-rds"
  rds_db_instance_engine = local.workspace.rds_db_instance_engine
  rds_db_instance_instance_class = local.workspace.rds_db_instance_instance_class
  rds_db_instance_allocated_storage = local.workspace.rds_db_instance_allocated_storage
}

module "s3" {
  source = "./module/s3"
  tags = local.tags
  s3_bucket = "${local.workspace.environment}-${var.project_name}-terraform-testing-s3"
}

module "ECR" {
  source = "./module/ECR"
  ecr_repository = "${local.workspace.environment}-${var.project_name}-ecr-repo"
  tags = local.tags
}

module "ALB" {
  source = "./module/ALB"
  tags = local.tags
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id[1]
  aws_lb = "${local.workspace.environment}-${var.project_name}-ecs-alb"
  aws_lb_target_group = "${local.workspace.environment}-${var.project_name}-ecs-alb-tg"
  alb-sg = "${local.workspace.environment}-${var.project_name}-alb-sg"
}
