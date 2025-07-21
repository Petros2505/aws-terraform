resource "aws_db_subnet_group" "rds" {
  name       = var.aws_db_subnet_group
  subnet_ids = var.private_subnet_id
  tags = merge(var.tags, {
    name = var.aws_db_subnet_group
  })
}

resource "aws_security_group" "rds" {
  name   = var.rds_aws_security_group
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    name = var.rds_aws_security_group
  })
}

resource "aws_db_instance" "rds" {
  identifier = var.rds_db_instance_identifier

  engine         = var.rds_db_instance_engine
  engine_version = var.rds_db_instance_engine_version
  instance_class = var.rds_db_instance_instance_class

  allocated_storage = var.rds_db_instance_allocated_storage
  storage_type      = var.rds_db_instance_storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = merge(var.tags, {
    name = var.rds_db_instance_identifier
  })
}