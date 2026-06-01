#this is for step-1 creating vpcs and subnets
module "network" {
  source = "./network"

  aws_region          = var.aws_region
  project_name        = var.project_name
  environment         = var.environment
  apple_dev_net       = var.apple_dev_net
  apple_dev_pub_net   = var.apple_dev_pub_net
  apple_dev_pvt_net   = var.apple_dev_pvt_net
}

#step-3 for creating RDS databases
module "database" {
  source = "./database"

  private_subnet_ids     = module.network.private_subnet_ids   # list of private subnet IDs
  rds_security_group_id  = module.network.rds_security_group_id
  project_name           = var.project_name
  environment            = var.environment
  db_username            = var.db_username
  db_password            = var.db_password
  db_name                = var.db_name
}

#step-4 adding ec2 instances 

module "compute" {
  source = "./compute"

  private_subnet_id     = module.network.private_subnet_id
  web_security_group_id = module.network.web_security_group_id
  project_name          = var.project_name
  environment           = var.environment
  key_name              = var.key_name
}
