resource "aws_ecr_repository" "api" {
  name = var.api_name
}
resource "aws_ecr_repository" "admin" {
  name = var.admin_name
}
resource "aws_ecr_repository" "swagger" {
  name = var.swagger_name
}
