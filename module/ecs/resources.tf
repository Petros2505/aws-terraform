resource "aws_iam_role" "ecs_instance_role" {
  name = var.ecs_instance_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = merge(var.tags, {

  })
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_user"
  role = aws_iam_role.ecs_instance_role.name
  tags = merge(var.tags, {

  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_ecs_cluster" "main" {
  name = var.aws_ecs_cluster
  tags = merge(var.tags, {

  })
}

resource "aws_security_group" "ecs_instance_sg" {
  name   = var.ecs_instance_sg
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    name = var.ecs_instance_sg
  })
}


resource "aws_launch_template" "ecs" {
  name_prefix            = var.ecs_launch_template
  image_id               = var.ecs_instance_ami
  instance_type          = var.ecs_instance_instance_type
  vpc_security_group_ids = [aws_security_group.ecs_instance_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
              EOF
  )
  tags = merge(var.tags, {
    name = var.ecs_launch_template
  })
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = var.ecs_instance_name
    })
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                = var.ecs_autoscaling_group
  vpc_zone_identifier = var.ecs_instance_subnet_id
  health_check_type   = "ELB"
  target_group_arns   = [var.target_group_arn]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}



resource "aws_ecs_task_definition" "nginx" {
  family                   = var.ecs_task_definition_family
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([{
    name   = var.container_definitions_name
    image  = var.container_definitions_iamge
    memory = var.container_definitions_memory
    portMappings = [{
      containerPort = var.container_definitions_containerPort
      hostPort      = var.container_definitions_hostPort
    }]

    environment = [
      {
        name  = "DB_HOST"
        value = var.DB_HOST
      },
      {
        name  = "DB_PORT"
        value = "3306"
      },
      {
        name  = "DB_NAME"
        value = var.db_name
      },
      {
        name  = "DB_USER"
        value = var.db_username
      },
      {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
    ]
  }])
  tags = merge(var.tags, {

  })
}

resource "aws_ecs_service" "nginx" {
  name            = var.ecs_service_nginx
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "EC2"
  tags = merge(var.tags, {

  })
}