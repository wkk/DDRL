provider "aws" {
  region = "us-east-2"
}

# Get the latest Ubuntu 18.04 server ami
# reference: https://www.terraform.io/docs/providers/aws/r/instance.html
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
  # Canonical
}

resource "aws_key_pair" "binwang-ddrl" {
  key_name = "binwang-ddrl"
  public_key = file("~/.ssh/binwang-ddrl.pub")
}

resource "aws_instance" "ddrl" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "g3s.xlarge"
  key_name = aws_key_pair.binwang-ddrl.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/.ssh/binwang-ddrl")
  }

  provisioner "remote-exec" {
    script = "bootstrap.sh"
  }

  provisioner "file" {
    source = "Dockerfile"
    destination = "Dockerfile"
  }

  provisioner "remote-exec" {
    inline = ["docker build . --quiet -t anaconda"]
  }
}

output "id" {
  value = aws_instance.ddrl.id
}

output "ip" {
  value = aws_instance.ddrl.public_ip
}
