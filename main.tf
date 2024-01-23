# Configuración del proveedor AWS
provider "aws" {
  region = var.region
}

module "instances" {
  source = "./modules/instance"

  instance_type    = var.instance_type
  key_name         = var.key_name
  backend_priv_ip  = var.backend_priv_ip
  frontend_priv_ip = var.frontend_priv_ip
  security_groups  = ["${module.network.security_group_id}"]
  subnet_id        = module.network.public_subnet_id
  ami_backend      = var.ami_backend
  ami_frontend     = var.ami_frontend
}

module "load_balancer" {
  source = "./modules/balancer"

  vpc_id          = module.network.vpc_id
  security_groups = ["${module.network.security_group_id}"]
  subnets         = ["${module.network.public_subnet_id}", "${module.network.public_subnet_id_b}"]
  frontendId      = module.instances.frontendId
}

module "network" {
  source = "./modules/network"
}
