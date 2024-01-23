variable "ami_backend" {
  type = string
}

variable "ami_frontend" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "backend_priv_ip" {
  type = string
}

variable "frontend_priv_ip" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

# Definición de la instancia EC2 para el backend
resource "aws_instance" "backend" {
  ami                    = var.ami_backend
  instance_type          = var.instance_type
  key_name               = var.key_name
  private_ip             = var.backend_priv_ip
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id
  associate_public_ip_address = true

  # Etiquetas para la instancia
  tags = {
    Name = "backend-instance"
  }
}

# Definición de la instancia EC2 para el frontend
resource "aws_instance" "frontend" {
  ami                    = var.ami_frontend
  instance_type          = var.instance_type
  key_name               = var.key_name
  private_ip             = var.frontend_priv_ip
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id
  associate_public_ip_address = true

  # Etiquetas para la instancia
  tags = {
    Name = "frontend-instance"
  }
}

output "frontendId" {
  value = aws_instance.frontend.id
}