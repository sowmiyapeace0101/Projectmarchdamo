provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "demo-server" {
  ami           = "ami-07a6e3b1c102cdba8"
  instance_type = "t2.micro"
  key_name = "projdamo"
  security_groups =["mysg"] 
  
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "SSH access"

ingress {
    description = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sshport"
  }
}
