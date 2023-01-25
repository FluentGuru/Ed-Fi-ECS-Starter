resource "aws_lb_target_group" "alb_tg" {
  name             = var.target_group_name
  target_type      = "ip"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id
}
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  ip_address_type    = "ipv4"
  subnets            = var.subnet_ids

}
#resource "aws_lb_target_group_attachment" "alb_tg" {
#  target_group_arn = aws_lb_target_group.alb_tg.arn
#  target_id        = aws_lb.alb.id
#port             = 80
#availability_zone = ["${var.vpc_region}a", "${var.vpc_region}b"]
#}
