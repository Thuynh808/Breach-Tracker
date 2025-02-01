# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow traffic to ECS tasks from ALB"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sg" {
  for_each = toset(var.private_subnet_cidr)

  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "ECS Ingress Rule for Private Subnets"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_sg" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "aws_ecr_image" "service_image" {
  repository_name = var.ecr_repository_name
  image_tag       = "latest"
}

resource "aws_ecs_cluster" "bt_cluster" {
  name = "${var.project_name}-cluster"
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_task_definition" "bt_task" {
  family = "${var.project_name}-task"
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = data.aws_ecr_image.service_image.image_uri
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "bt_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.bt_cluster.id
  task_definition = aws_ecs_task_definition.bt_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  depends_on      = [var.ecs_task_role_arn]
  network_configuration {
    subnets          = var.private_subnet_id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  enable_execute_command = true
  force_new_deployment   = true
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app-container"
    container_port   = 80
  }
}
