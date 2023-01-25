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
