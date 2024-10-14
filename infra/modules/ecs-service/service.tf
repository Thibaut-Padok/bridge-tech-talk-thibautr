resource "aws_ecs_service" "this" {
  name                   = var.config.name
  cluster                = var.cluster.id
  task_definition        = aws_ecs_task_definition.this.arn
  desired_count          = var.config.desired_count
  force_new_deployment   = true
  enable_execute_command = true

  network_configuration {
    subnets          = var.private_subnets_ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.service.id
    ]
  }

  dynamic "load_balancer" {
    for_each = var.lb.enabled ? [1] : []
    content {
      target_group_arn = var.lb.target_group_arn
      container_name   = var.config.containers["main"].name # alwatys use the first container (not the sidecar one)
      container_port   = var.config.containers["main"].port # alwatys use the first container (not the sidecar one)
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      capacity_provider_strategy,
    ]
  }
}

resource "aws_security_group" "service" {
  name   = "${var.cluster.name}-${var.config.name}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.lb.enabled ? [1] : []
    content {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = [var.lb.security_group_id]
    }
  }

  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = [var.bastion_sg]
  }

  dynamic "ingress" {
    for_each = var.remote_debug_enabled ? [1] : []
    content {
      from_port        = 9229
      to_port          = 9229
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [var.bastion_sg]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
