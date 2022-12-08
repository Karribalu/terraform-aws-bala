provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "myfirst" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["${aws_security_group.allow_all.name}"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./balu-key.pem")
      host        = aws_instance.myfirst.public_ip
    }
  }
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all_2"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-05807f8a3762c6cf4"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


