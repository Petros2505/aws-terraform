resource "aws_lb" "ecs_alb" {
  name                       = var.aws_lb
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb-sg.id]
  subnets                    = [var.public_subnet_id, var.private_subnet_id]
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

  dynamic "health_check" {
    for_each = var.alb_health_check
    content {
      enabled             = health_check.value.enabled
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
      timeout             = health_check.value.timeout
      interval            = health_check.value.interval
      path                = health_check.value.path
      matcher             = health_check.value.matcher
      port                = health_check.value.port
      protocol            = health_check.value.protocol
    }
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

  dynamic "ingress" {
    for_each = var.alb_sg_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.alb_sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = merge(var.tags, {
    name = var.alb-sg
  })
}