

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.3.0"

  name = "${var.ecs_cluster_name}-ecs-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnet_id
  security_groups = [aws_security_group.allow_tls.id]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        enabled             = true
        interval            = 60
        path                = "/healthz"
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:eu-west-3:203326423340:certificate/5ef7049e-0588-4157-89d4-57474daf9c50"
      target_group_index = 0
    }
  ]
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.ecs_cluster_name}-ecs-sg"
  description = "Allow TLS inbound traffic for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
