resource "aws_api_gateway_rest_api" "bt_api" {
  name        = "${var.project_name}-api"
  description = "API Gateway for Breach Tracker"
}

resource "aws_api_gateway_resource" "breaches" {
  rest_api_id = aws_api_gateway_rest_api.bt_api.id
  parent_id   = aws_api_gateway_rest_api.bt_api.root_resource_id
  path_part   = "breaches"
}

resource "aws_api_gateway_method" "breaches_get" {
  rest_api_id   = aws_api_gateway_rest_api.bt_api.id
  resource_id   = aws_api_gateway_resource.breaches.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "alb_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bt_api.id
  resource_id             = aws_api_gateway_resource.breaches.id
  http_method             = aws_api_gateway_method.breaches_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.alb_dns_name}/breaches"

  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.alb_integration]
  rest_api_id = aws_api_gateway_rest_api.bt_api.id
  stage_name  = "prod"
}
