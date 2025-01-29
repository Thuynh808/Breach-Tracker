# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow traffic to ECS tasks from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id] # Restrict to ALB security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

resource "aws_ecr_repository" "bt_ecr" {
  name = var.project_name
  tags = {
    Name = "${var.project_name}-ecr"
  }
}

resource "aws_ecs_cluster" "bt_cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "bt_task" {
  family = "${var.project_name}-task"
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = "${aws_ecr_repository.bt_ecr.repository_url}:latest"
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
  network_configuration {
    subnets          = var.private_subnet
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app-container"
    container_port   = 80
  }
}


