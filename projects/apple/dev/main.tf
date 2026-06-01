module "network" {
  source = "./network"

  aws_region          = var.aws_region
  project_name        = var.project_name
  environment         = var.environment
  apple_dev_net       = var.apple_dev_net
  apple_dev_pub_net   = var.apple_dev_pub_net
  apple_dev_pvt_net   = var.apple_dev_pvt_net
}
