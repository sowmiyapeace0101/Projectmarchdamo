provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "demo-server" {
  ami           = "ami-07a6e3b1c102cdba8"
  instance_type = "t2.micro"
  key_name = "projdamo"
  
}