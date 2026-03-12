# ===========================================================
# DEMO: EC2 en VPC con Subnet Pública
# Masterclass Terraform - Bootcamperu
# ===========================================================

# === BLOQUE 1: PROVIDER ===
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Proyecto  = "Bootcamperu"
      ManagedBy = "terraform"
    }
  }
}

# backend.tf - Estado en S3
terraform {
  backend "s3" {
    bucket         = "bootcamperu-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
  }
}


# === BLOQUE 2: RED - VPC ===
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-demo"
  }
}

# === BLOQUE 3: RED - INTERNET GATEWAY ===
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-demo"
  }
}

# === BLOQUE 4: RED - SUBNET PÚBLICA ===
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-publica-demo"
  }
}

# === BLOQUE 5: RED - TABLA DE RUTAS ===
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-publica-demo"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# === BLOQUE 6: SEGURIDAD - SECURITY GROUP ===
resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-demo"
  description = "Permite acceso SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH desde internet"
    from_port   = 22
    to_port     = 22
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
    Name = "sg-ssh-demo"
  }
}

# === BLOQUE 7: CÓMPUTO - DATA SOURCE AMI === AMI = Amazon Machine Image
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# === BLOQUE 8: CÓMPUTO - INSTANCIA EC2 ===
resource "aws_instance" "web" {
  count = 3
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ec2-demo"
  }
}

# === BLOQUE 9: OUTPUTS ===
# output "instance_public_ip" {
#   description = "IP pública de la instancia EC2"
#   value       = aws_instance.web.public_ip
# }

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}
