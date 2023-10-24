provider "aws" {
  region = "ap-south-1"
}

resource "tls_private_key" "rsa_4096" {
  key_name   = "RSA"
  rsa_bits   = 4096
}
  
  variable "key_name"{}
  
resource "aws_key_pair" "my-key-pair" {
  key_name   = "var.key_name"
  public_key = tls_private_key.rsa_4096.public_key_openssh

}

resource "local_file" "private_key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "var.key_name"
}

resource "aws_security_group" "my-security-group" {
  name = "my-security-group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-instance" {
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my-security-group.name]
  key_name=aws_key_pair.my-key-pair.key_name
  
  tag = {
  Name = "public_instance"
}
}
