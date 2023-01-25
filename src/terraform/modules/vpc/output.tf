output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID of the VPC created."
}
output "vpc_sg_id" {
  value       = module.vpc.default_security_group_id
  description = "ID of the default sg created."
}
output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "IDs of the private subnets created."
}
output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "IDs of the public subnets created."
}
