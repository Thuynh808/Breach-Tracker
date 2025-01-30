# create api gateway
resource "aws_apigatewayv2_api" "bt_api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "bt_vpc_link" {
  name               = "${var.project_name}-vpc-link"
  security_group_ids = [var.alb_security_group_id]
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
  integration_uri    = "http://${var.alb_dns_name}/{proxy+}"
}

resource "aws_apigatewayv2_route" "bt_route" {
  api_id    = aws_apigatewayv2_api.bt_api.id
  route_key = "ANY /example/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.bt_integration.id}"
}

resource "aws_apigatewayv2_stage" "bt_stage" {
  api_id = aws_apigatewayv2_api.bt_api.id
  name   = "dev"
}

resource "aws_apigatewayv2_deployment" "bt_deployment" {
  api_id = aws_apigatewayv2_api.bt_api.id

  depends_on = [
    aws_apigatewayv2_route.bt_route
  ]

  lifecycle {
    create_before_destroy = true
  }
}
