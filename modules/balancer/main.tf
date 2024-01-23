variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "frontendId" {
  type = string
}

# Un Target Group se utiliza para enrutar solicitudes a uno o más objetivos registrados.
# Necesitamos uno para el balance de cargas
resource "aws_lb_target_group" "mean_tg" {
  name     = "mean-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

# Adjuntamos el Target Group a la instancia del Frontend
resource "aws_lb_target_group_attachment" "mean_lb" {
  target_group_arn = aws_lb_target_group.mean_tg.arn
  target_id = var.frontendId
  port = 80
}

# Creamos el Load Balancer y adjuntamos el grupo de seguridad y a las subnets públicas
resource "aws_lb" "mean_alb" {
  name               = "mean-alb"
  internal           = false
  load_balancer_type = "application"

  enable_deletion_protection = false

  enable_http2 = true

  security_groups = var.security_groups
  subnets         = var.subnets

  tags = {
    Environment = "development"
  }
}

# Un listener es un proceso que escucha las solicitudes de conexión usnado el protocolo y puerto definidos
# Con el listener vamos a asociar el Load balancer con el Target Group
resource "aws_lb_listener" "mean_end" {
  load_balancer_arn = aws_lb.mean_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.mean_tg.arn
  }
}