# task definition
data "template_file" "task_definition" {
  template = file(join("/", [abspath(path.root), var.task_definition_file]))

  vars = merge({
    container_memory = var.container_memory
    container_cpu    = var.container_cpu
    container_port   = var.container_port
    container_name   = var.container_name
    project_name     = var.project_name
    task_name        = var.task_name
    region           = var.region
    stage            = var.stage
  }, var.extra_task_definition_vars)
}

# main
resource "aws_ecs_cluster" "cluster" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "task" {
  family = var.task_name

  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  execution_role_arn       = aws_iam_role.task_exec_role.arn
}

resource "aws_security_group" "svc_sg" {
  name_prefix = var.project_name
  description = "inbound from load balancer to ecs service"

  vpc_id = var.vpc_id

  ingress {
    description     = "inbound from load balancer"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    self            = true
  }
  egress {
    description = "outbound traffic to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = local.svc_name }, var.tags)
}

resource "aws_ecs_service" "svc" {
  name            = local.svc_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  load_balancer {
    container_name   = var.container_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.default.arn
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = concat([aws_security_group.svc_sg.id], var.additional_security_group_ids)
    assign_public_ip = true
  }
  depends_on = [aws_lb.alb, aws_lb_listener.https]
  tags       = var.tags
}
