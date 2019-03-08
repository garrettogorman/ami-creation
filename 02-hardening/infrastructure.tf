provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "temp" {
  name        = "temp-sg"
  description = "Allow traffic to ssh port"
  vpc_id      = "${var.vpc_id}"

  ingress {
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
}

resource "aws_instance" "basic-vm" {
  ami           = "ami-0e12cbde3e77cbb98"
  instance_type = "t2.micro"

  key_name = "Bastion-Key"

  vpc_security_group_ids = ["${aws_security_group.temp.id}"]

  tags {
    Name = "ami-testing"
  }

  root_block_device {
    delete_on_termination = "true"
  }
}

output "instance_private_ip" {
  value = ["${aws_instance.basic-vm.*.private_ip}"]
}
