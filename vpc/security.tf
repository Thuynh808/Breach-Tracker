# Security Group for ECS Tasks
resource "aws_security_group" "ecs" {
  vpc_id      = aws_vpc.main.id
  name        = "ecs-sg"
  description = "Allow inbound and outbound traffic for ECS tasks"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  vpc_id      = aws_vpc.main.id
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

