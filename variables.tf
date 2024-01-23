variable "ami_backend" {
  type = string
  default = "ami-0d25088cebe095dff"
}

variable "ami_frontend" {
  type = string
  default = "ami-0ef2eb0f9b8e704d9"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "region" {
  type = string
  default = "us-west-2"
}

variable "key_name" {
  type = string
  default = "ec2_keys"
}

variable "backend_priv_ip" {
  type = string
  default = "172.31.10.10"
}

variable "frontend_priv_ip" {
  type = string
  default = "172.31.10.20"
}
