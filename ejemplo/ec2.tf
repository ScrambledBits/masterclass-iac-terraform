
data "aws_ami" "ubuntu" { # Amazon Machine Image
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_pet" "server" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = data.aws_ami.ubuntu.id
  }
}

resource "aws_instance" "ejemplo" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  primary_network_interface {
    network_interface_id = aws_network_interface.ejemplo.id
  }

  tags = {
    Name = "Ejemplo Bootcamperu ${random_pet.server.id}"
  }
}

resource "aws_network_interface" "ejemplo" {
  subnet_id       = aws_subnet.publica.id
  private_ips     = ["10.0.1.100"]
  security_groups = [aws_security_group.web_ssh.id]

  tags = {
    Name = "primary_network_interface"
  }
}
