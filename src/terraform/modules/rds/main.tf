
# module "db" {
#   source     = "terraform-aws-modules/rds/aws"
#   version    = "5.1.1"
#   identifier = var.db_name

#   engine                = "postgres"
#   engine_version        = "13.7"
#   instance_class        = var.db_instance_class
#   allocated_storage     = 20
#   max_allocated_storage = 100

#   username = var.db_username
#   password = var.db_password
#   #port     = "5432"
#   publicly_accessible = true

#   iam_database_authentication_enabled = true

#   vpc_security_group_ids    = var.security_group_ids
#   create_db_parameter_group = false
#   # DB subnet group
#   create_db_subnet_group = false
#   #db_subnet_group_name   = "edfi-subnets"
#   #subnet_ids             = [module.vpc.private_subnets, module.vpc.public_subnets]
#   subnet_ids = var.subnet_ids
# }
resource "aws_db_subnet_group" "rds_subnets_public" {
  name       = "edfi-public-subnets"
  subnet_ids = var.public_subnet_ids
}
resource "aws_db_subnet_group" "rds_subnets_private" {
  name       = "edfi-private-subnets"
  subnet_ids = var.private_subnet_ids
}
resource "aws_db_instance" "rds" {
  allocated_storage     = 20
  max_allocated_storage = 100
  identifier            = var.db_name
  #db_name = "postgres"
  engine                              = "postgres"
  engine_version                      = "13.7"
  instance_class                      = var.db_instance_class
  username                            = var.db_username
  password                            = var.db_password
  iam_database_authentication_enabled = true
  publicly_accessible                 = true
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot    = true
  multi_az               = true
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets_public.name
}
