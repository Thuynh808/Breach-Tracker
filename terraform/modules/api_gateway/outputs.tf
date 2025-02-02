output "api_endpoint" {
  value       = aws_apigatewayv2_stage.bt_stage.invoke_url
  description = "API Gateway Invoke URL"
}

output "vpc_link_sg_id" {
  value       = aws_security_group.vpc_link_sg.id
  description = "security group id of vpc link"
}

