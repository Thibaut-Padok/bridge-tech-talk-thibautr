resource "aws_cloudwatch_log_group" "this" {
  name = var.config.name
}

locals {
  debug_port_mapping = var.remote_debug_enabled ? [
    {
      containerPort = 9229,
      hostPort      = 9229,
      protocol      = "tcp"
    }
  ] : []
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.config.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.config.cpu
  memory                   = var.config.memory

  execution_role_arn = aws_iam_role.this.arn
  task_role_arn      = aws_iam_role.this.arn

  # TODO: Add log configuration
  container_definitions = jsonencode([
    for container in var.config.containers :
    {
      name        = container.name,
      image       = container.image,
      cpu         = 0   # No container specific contraints
      user        = "0" # No container specific contraints
      volumesFrom = []

      portMappings = concat(container.port != null ? [
        {
          containerPort = container.port,
          hostPort      = container.port
          protocol      = "tcp"
        }
      ] : [], local.debug_port_mapping),
      environment = [for k, v in container.environment : { name = k, value = v }],
      secrets     = [for k, v in container.secrets : { name = k, valueFrom = v }]
      networkMode = "awsvpc",
      essential   = true
      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:3000/healthz || exit 1"
        ],
        interval = 60,
        timeout  = 5,
        retries  = 5
      },
    }
  ])
}
