# create api gateway
resource "aws_apigatewayv2_api" "bt_api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}

data "aws_ip_ranges" "api_gateway" {
  services = ["API_GATEWAY"]
  regions  = ["us-east-1"]
}

resource "aws_security_group" "vpc_link_sg" {
  name        = "${var.project_name}-vpc-link-sg"
  description = "allow HTTP traffic to the vpc-link"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "http_rule" {
  for_each = toset(data.aws_ip_ranges.api_gateway.cidr_blocks)

  security_group_id = aws_security_group.vpc_link_sg.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https_rule" {
  for_each = toset(data.aws_ip_ranges.api_gateway.cidr_blocks)

  security_group_id = aws_security_group.vpc_link_sg.id
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "vpc_link_sg" {
  security_group_id = aws_security_group.vpc_link_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_apigatewayv2_vpc_link" "bt_vpc_link" {
  name               = "${var.project_name}-vpc-link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids         = var.private_subnet_id

  tags = {
    Name = "${var.project_name}-vpc-link"
  }
}

resource "aws_apigatewayv2_integration" "bt_integration" {
  api_id             = aws_apigatewayv2_api.bt_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.bt_vpc_link.id
  integration_uri    = var.alb_listener_arn
}

resource "aws_apigatewayv2_route" "bt_route" {
  api_id    = aws_apigatewayv2_api.bt_api.id
  route_key = "GET /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.bt_integration.id}"
}

resource "aws_apigatewayv2_stage" "bt_stage" {
  api_id      = aws_apigatewayv2_api.bt_api.id
  name        = "$default"
  auto_deploy = true

  depends_on = [
    var.ecs_service,
    aws_apigatewayv2_route.bt_route,
    aws_apigatewayv2_integration.bt_integration
  ]
}

resource "aws_apigatewayv2_deployment" "bt_deployment" {
  api_id = aws_apigatewayv2_api.bt_api.id

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.bt_integration),
      jsonencode(aws_apigatewayv2_route.bt_route)
    ])))
  }

  depends_on = [
    var.ecs_service,
    aws_apigatewayv2_route.bt_route,
    aws_apigatewayv2_integration.bt_integration,
    aws_apigatewayv2_stage.bt_stage
  ]

  lifecycle {
    create_before_destroy = true
  }
}
