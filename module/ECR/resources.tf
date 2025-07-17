resource "aws_ecr_repository" "app" {
  name = var.ecr_repository

  tags =merge(var.tags, { 
    Name = var.ecr_repository

  })
  }