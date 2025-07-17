resource "aws_lb" "ecs_alb" {
  name               = var.aws_lb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public_subnet_id,var.private_subnet_id]  
  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = var.aws_lb
  })
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = var.aws_lb_target_group
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = 80
    protocol            = "HTTP"
  }

  tags = merge(var.tags, {
    Name = var.aws_lb_target_group
  })
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_security_group" "alb-sg" {
  name   = var.alb-sg
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags =merge(var.tags, { 
    name = var.alb-sg
  })
}