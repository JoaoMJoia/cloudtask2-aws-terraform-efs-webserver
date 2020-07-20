provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "C:/Users/KIIT/.aws/credentials"
  profile                 = "chirag"
}

resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
}

resource "local_file" "privatekey" {
    content     = tls_private_key.keypair.private_key_pem
    filename = "key1.pem"
}

resource "aws_key_pair" "deployer" {
  key_name   = "key1.pem"
  public_key = tls_private_key.keypair.public_key_openssh
}