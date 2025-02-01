# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
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

# Attach the ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.ecs_task_execution_policy
}

# ECS Task Role (Allows ECS tasks to make API requests or access AWS services)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
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

# create cloudwatch log group for ecs task logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/aws/ecs/${var.project_name}"
  retention_in_days = 30
  tags = {
    Name = "${var.project_name}-ecs-log-group"
  }
}

# Custom IAM Policy for ECS Task Role (Adjust permissions as needed)
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.project_name}-ecs-task-policy"
  description = "Policy for ECS task to call Have I Been Pwned API and store logs/data"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow ECS tasks to make requests to external APIs (HIBP)
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.ecs_log_group.arn}:log-stream:/aws/ecs/${var.project_name}/*"
      },

      # Allow ECS to make outgoing API requests (needed for API calls via NAT Gateway)
      {
        Effect = "Allow",
        Action = [
          "ecs:*",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface"
        ],
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


# API Gateway Execution Role
resource "aws_iam_role" "api_gateway_execution_role" {
  name = "${var.project_name}-api-gateway-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-api-gateway-execution-role"
  }
}

# Create CloudWatch Log Group for API Gateway Logs
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/apigateway/${var.project_name}"
  retention_in_days = 30
  tags = {
    Name = "${var.project_name}-api-gateway-log-group"
  }
}


# Custom IAM Policy for API Gateway
resource "aws_iam_policy" "api_gateway_policy" {
  name        = "${var.project_name}-api-gateway-policy"
  description = "API Gateway integration with ALB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow API Gateway to interact with ALB
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        Resource = var.alb_arn
      },

      # Allow API Gateway to write logs (optional)
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
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

