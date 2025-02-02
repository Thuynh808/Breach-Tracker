# ECS Task Execution Role - For pulling images & sending logs
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-execution-role"
  }
}

# Attach AWS Managed Policy for ECS Task Execution (IAM Best Practice)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role - For ECS Tasks to Access APIs & Logging
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

# CloudWatch Log Group for ECS Task Logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/aws/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-ecs-log-group"
  }
}

# Custom IAM Policy for ECS Task Role (Granular Permissions)
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.project_name}-ecs-task-policy"
  description = "Least Privilege Policy for ECS Task"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Logging to CloudWatch
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "${aws_cloudwatch_log_group.ecs_log_group.arn}:log-stream:/aws/ecs/${var.project_name}/*"
      },
      # Allow ECS Task to Describe Network Interfaces (Necessary for ENI-based Networking)
      {
        Effect   = "Allow",
        Action   = ["ec2:DescribeNetworkInterfaces"],
        Resource = "*"
      }
    ]
  })
}

# Attach Custom Policy to ECS Task Role
resource "aws_iam_role_policy_attachment" "ecs_task_role_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}

# API Gateway Execution Role - For API Gateway to Invoke ALB
resource "aws_iam_role" "api_gateway_execution_role" {
  name = "${var.project_name}-api-gateway-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-api-gateway-execution-role"
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/apigateway/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-api-gateway-log-group"
  }
}

# Custom IAM Policy for API Gateway (Restricted to ALB)
resource "aws_iam_policy" "api_gateway_policy" {
  name        = "${var.project_name}-api-gateway-policy"
  description = "API Gateway Permissions for ALB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # API Gateway Access to ALB
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth"
        ],
        Resource = var.alb_arn
      },
      # API Gateway CloudWatch Logging
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "${aws_cloudwatch_log_group.api_gateway_log_group.arn}:*"
      }
    ]
  })
}

# Attach Custom Policy to API Gateway Execution Role
resource "aws_iam_role_policy_attachment" "api_gateway_attach" {
  role       = aws_iam_role.api_gateway_execution_role.name
  policy_arn = aws_iam_policy.api_gateway_policy.arn
}

