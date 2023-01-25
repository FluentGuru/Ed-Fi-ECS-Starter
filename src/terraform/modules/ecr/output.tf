output "api_url" {
  description = "The URL of the api repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value       = aws_ecr_repository.api.repository_url
}
output "api_id" {
  description = "The registry ID where the api repository was created."
  value       = aws_ecr_repository.api.registry_id
}
output "admin_url" {
  description = "The URL of the admin repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value       = aws_ecr_repository.admin.repository_url
}
output "admin_id" {
  description = "The registry ID where the admin repository was created."
  value       = aws_ecr_repository.admin.registry_id
}

output "swagger_url" {
  description = "The URL of the swagger repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value       = aws_ecr_repository.swagger.repository_url
}
output "swagger_id" {
  description = "The registry ID where the swagger repository was created."
  value       = aws_ecr_repository.swagger.registry_id
}
