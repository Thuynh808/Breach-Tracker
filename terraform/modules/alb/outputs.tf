output "alb_arn" {
  value       = aws_lb.alb.arn
  description = "arn of ALB"
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.ecs_tg.arn
  description = "ARN of the ALB target group for ECS"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.http_listener.arn
  description = "alb listener arn"
}
