output "alb_id" {
  value       = aws_lb.alb.id
  description = "The ARN and ID of the load balancer"
}
output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "The DNS name of the load balancer."
}
output "alb_zone_id" {
  value       = aws_lb.alb.zone_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}
output "tg_id" {
  value       = aws_lb_target_group.alb_tg.id
  description = "The ARN and ID of the taget group."
}
