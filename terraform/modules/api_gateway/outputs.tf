output "api_endpoint" {
  value       = aws_api_gatewayv2_stage.bt_stage.invoke_url
  description = "API Gateway Invoke URL"
}

