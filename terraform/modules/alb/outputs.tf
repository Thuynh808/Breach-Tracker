output "alb_dns" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB security group"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.ecs_tg.arn
  description = "ARN of the ALB target group for ECS"
}

