variable "db_username" {
  description = "DB administrator username"
  type        = string
  default     = "postgres"
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

variable "security_group_ids" {
  type = list(any)
}
#variable "subnet_ids" {
#  type = list(any)
#}
variable "public_subnet_ids" {
  type = list(any)
}
variable "private_subnet_ids" {
  type = list(any)
}
variable "db_name" {
  type    = string
  default = "ed-fi-aws-rds"
}
