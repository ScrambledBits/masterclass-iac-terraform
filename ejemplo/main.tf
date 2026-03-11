# - Crear una VPC
# - Crear una subred pública
# - Crear una instancia EC2 dentro de la subred pública
# - Crear un grupo de seguridad que permita el tráfico HTTP (puerto 80) y SSH (puerto 22)
# - Asociar el grupo de seguridad a la instancia EC2


resource "aws_vpc" "principal" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "principal"
  }
}

resource "aws_subnet" "publica" {
  vpc_id     = aws_vpc.principal.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Publica"
  }
}

resource "aws_security_group" "web_ssh" {
  name        = "web-ssh"
  description = "Permite trafico HTTP y SSH"
  vpc_id      = aws_vpc.principal.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-ssh"
  }
}
