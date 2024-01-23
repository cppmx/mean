# Creamos una VPC
resource "aws_vpc" "mean_vpc" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "MEAN VPC"
  }
}

# Creamos una subnet pública en us-west-2a
resource "aws_subnet" "mean_public_subnet" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = "172.31.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "MEAN Public Subnet"
  }
}

# Creamos una subnet pública en us-west-2b
resource "aws_subnet" "mean_public_subnetb" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = "172.31.15.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "MEAN Public Subnet"
  }
}

# Creamos una subnet privada
resource "aws_subnet" "mean_private_subnet" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = "172.31.20.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "MEAN Private Subnet"
  }
}

# Adjuntamos el gateway para internet
resource "aws_internet_gateway" "mean_ig" {
  vpc_id = aws_vpc.mean_vpc.id

  tags = {
    Name = "MEAN Internet Gateway"
  }
}

# Creamos la tabla de ruteo público
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mean_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mean_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.mean_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Asociamos las subredes
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.mean_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Definición del grupo de seguridad
resource "aws_security_group" "web" {
  name        = "mean-sg"                     # Nombre del grupo de seguridad
  description = "Permitir el trafico mediante los puertos 22, 80, 443, y 3000"
  vpc_id = aws_vpc.mean_vpc.id

  # Reglas de ingreso para el grupo de seguridad
  ingress {
    description = "SSH para la red privada"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/24"]
  }

  ingress {
    description = "SSH para la red publica"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acceso web a traves del puerto 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acceso web a traves del puerto 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acceso al backend a traves del puerto 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permitir todo el trafico de salida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "vpc_id" {
  value = aws_vpc.mean_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.mean_public_subnet.id
}

output "public_subnet_id_b" {
  value = aws_subnet.mean_public_subnetb.id
}

output "private_subnet_id" {
  value = aws_subnet.mean_private_subnet.id
}