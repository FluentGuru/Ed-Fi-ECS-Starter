## Multi AZ VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name    = var.vpc_name
  cidr    = var.vpc_cidr

  azs             = ["${var.vpc_region}a", "${var.vpc_region}b"]
  private_subnets = [var.private_subnet_1_cidr, var.private_subnet_2_cidr]
  public_subnets  = [var.public_subnet_1_cidr, var.public_subnet_2_cidr]

  create_igw             = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

}

# module "endpoints" {
#   source             = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version            = "3.18.1"
#   vpc_id             = module.vpc.vpc_id
#   security_group_ids = [module.vpc.default_security_group_id]

#   endpoints = {
#     s3 = {
#       # interface endpoint
#       service = "s3"
#       tags    = { Name = "s3-vpc-endpoint" }
#     },
#   }

# }

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = module.vpc.vpc_id
  service_name    = "com.amazonaws.${var.vpc_region}.s3"
  route_table_ids = module.vpc.private_route_table_ids
  tags            = { Name = "${var.vpc_name}-s3-vpe" }
}
