variable "vpc_name" {
  description = "The name of the VPC to create."
  type        = string
}
variable "vpc_cidr" {
  description = "The CIDR of the VPC to create."
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_1_cidr" {
  description = "The CIDR of the public subnet 1."
  type        = string
  default     = "10.0.0.0/20"
}
variable "public_subnet_2_cidr" {
  description = "The CIDR of the public subnet 1."
  type        = string
  default     = "10.0.16.0/20"
}
variable "private_subnet_1_cidr" {
  description = "The CIDR of the private subnet 1."
  type        = string
  default     = "10.0.128.0/20"
}
variable "private_subnet_2_cidr" {
  description = "The CIDR of the private subnet 2."
  type        = string
  default     = "10.0.144.0/20"
}
variable "vpc_region" {
  description = "The region of the VPC to create."
  type        = string
  default     = "us-east-1"
}
variable "api_ecr_name" {
  description = "The name of the api repo."
  type        = string
  default     = "edfi-ods-api"
}
variable "admin_ecr_name" {
  description = "The name of the admin repo."
  type        = string
  default     = "edfi-ods-adminapp"
}
variable "swagger_ecr_name" {
  description = "The name of the swagger repo."
  type        = string
  default     = "edfi-ods-swagger"
}
variable "db_username" {
  description = "DB administrator username"
  type        = string
  sensitive   = false
}

variable "db_password" {
  description = "DB administrator password"
  type        = string
  sensitive   = true
}
variable "db_instance_class" {
  description = "The instance class of the RDS to create."
  type        = string
  default     = "db.t3.medium"
}
variable "db_name" {
  type    = string
  default = "ed-fi-aws-rds"
}
variable "target_group_name" {
  type    = string
  default = "ed-fi-aws-tg"
}
variable "alb_name" {
  type    = string
  default = "ed-fi-aws-lb"
}
