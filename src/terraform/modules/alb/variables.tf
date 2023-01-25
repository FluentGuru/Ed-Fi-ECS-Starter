variable "vpc_id" {
  type = string
}
variable "security_group_ids" {
  type = list(any)
}
variable "subnet_ids" {
  type = list(any)
}
variable "target_group_name" {
  type    = string
  default = "ed-fi-aws-tg"
}
variable "alb_name" {
  type    = string
  default = "ed-fi-aws-lb"
}
