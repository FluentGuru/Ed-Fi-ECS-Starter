## Multi AZ VPC
module "vpc" {
  source                = "./modules/vpc"
  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  vpc_region            = var.vpc_region
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}
# Elastic container registries
module "ecr" {
  source       = "./modules/ecr"
  api_name     = var.api_ecr_name
  admin_name   = var.admin_ecr_name
  swagger_name = var.swagger_ecr_name
}


# RDS instance
module "rds" {
  source             = "./modules/rds"
  security_group_ids = [module.vpc.vpc_sg_id]
  #subnet_ids = setunion(
  #  module.vpc.private_subnets,
  #  module.vpc.public_subnets,
  #)
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  db_name            = var.db_name
}

# base load balancer
module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  target_group_name  = var.target_group_name
  alb_name           = var.alb_name
  security_group_ids = [module.vpc.vpc_sg_id]
  #subnet_ids = setunion(
  #  module.vpc.private_subnets,
  #  module.vpc.public_subnets,
  #)
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]
}

resource "local_file" "start" {
  #count = fileexists("../../${path.module}/env.ps1") ? 0 : 1
  filename = "../../${path.module}/env.ps1"
  content  = <<-EOT
    # See START.md for more info about the environment variables.
    # AWS Credentials
    $env:AWS_ACCESS_KEY_ID="YOUR ACCESS ID"
    $env:AWS_SECRET_ACCESS_KEY="YOUR ACCESS SECRET"
    $env:AWS_SESSION_TOKEN="YOUR SESSION TOKEN (if using 2FA on your AWS account)"
    $env:AWS_DEFAULT_REGION="${var.vpc_region}"

    # AWS Dependencies
    $env:AWS_VPC_ID="${module.vpc.vpc_id}"
    $env:AWS_LB_NAME="${var.alb_name}"
    $env:AWS_LB_HOSTNAME="${module.alb.alb_dns_name}"
    $env:AWS_ECR_URL="${module.ecr.api_id}.dkr.ecr.${var.vpc_region}.amazonaws.com"
    $env:AWS_SG_ID="${module.vpc.vpc_sg_id}"

    # AWS ECR/Docker
    $env:TAG="latest"

    # Database config
    $env:PGHOST = "${trimsuffix(module.rds.db_instance_endpoint, ":${module.rds.db_instance_port}")}"
    $env:PGPORT = ${module.rds.db_instance_port}
    $env:PGUSER = "${var.db_username}"
    $env:PGPASSWORD = "${var.db_password}"

    # Ed-Fi configuration
    $env:COMPOSE_PROJECT_NAME="developersnet-edfi-shared"
    $env:POPULATED_KEY="populatdedKey"
    $env:POPULATED_SECRET="populateddSecret"
    $env:ENCRYPTION_KEY="r2bemkTvjsRURdur0+dc49eaON140QRkQzgQwPdht8Lk="
    $env:ADMIN_USER="admin@test.com"
    $env:ADMIN_PASSWORD="Admin41"
    EOT
}
