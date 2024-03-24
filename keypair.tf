resource "aws_key_pair" "key-pair" {
  key_name   = "key-pair"
  public_key = tls_private_key.RSA.public_key_openssh

  tags = {
    Name = "key-pair"
  }
}

resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private-key-file" {
  content  = tls_private_key.RSA.private_key_pem
  filename = "bestseller-key-pair.pem"
}