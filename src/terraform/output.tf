output "AWS_VPC_ID" {
  value       = module.vpc.vpc_id
  description = "ID of the VPC created."
}
output "AWS_SG_ID" {
  value       = module.vpc.vpc_sg_id
  description = "ID of the default sg created."
}
output "AWS_LB_HOSTNAME" {
  value       = module.alb.alb_dns_name
  description = "The DNS name of the load balancer."
}
output "AWS_LB_NAME" {
  value       = var.alb_name
  description = "The name of the load balancer."
}
output "AWS_ECR_URL" {
  value       = "${module.ecr.api_id}.dkr.ecr.${var.vpc_region}.amazonaws.com"
  description = "url of the AWS ECR repository that will host the starter docker images."
}
output "PGHOST" {
  value       = trimsuffix(module.rds.db_instance_endpoint, module.rds.db_instance_port)
  description = "url of the RDS instance."
}
output "PGPORT" {
  value       = module.rds.db_instance_port
  description = "port of the RDS instance."
}
output "PGUSER" {
  value       = var.db_username
  description = "user of the RDS instance."
  sensitive   = false
}
