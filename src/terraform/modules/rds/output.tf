# output "db_instance_id" {
#   value       = module.db.db_instance_id
#   description = "The RDS instance ID"
# }
# output "db_instance_endpoint" {
#   value       = module.db.db_instance_endpoint
#   description = "The connection endpoint"
# }
# output "db_instance_port" {
#   value       = module.db.db_instance_port
#   description = "The connection endpoint port"
# }
# output "db_instance_resource_id" {
#   value       = module.db.db_instance_resource_id
#   description = "The RDS Resource ID of this instance"
# }



output "db_instance_id" {
  value       = aws_db_instance.rds.id
  description = "The RDS instance ID"
}
output "db_instance_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "The connection endpoint"
}
output "db_instance_port" {
  value       = aws_db_instance.rds.port
  description = "The connection endpoint port"
}
output "db_instance_resource_id" {
  value       = aws_db_instance.rds.resource_id
  description = "The RDS Resource ID of this instance"
}
