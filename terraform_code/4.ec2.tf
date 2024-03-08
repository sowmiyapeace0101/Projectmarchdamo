provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "my-instance" {
  ami   = "ami-0123c9b6bfb7eb962"
  instance_type = "t2.micro"
  key_name = "projdamo"
  //security_groups =["my-sg"] 
  subnet_id = aws_subnet.my-pub-subnet-01.id
    for_each = toset(["Jenkins master", "Jenkins slave", "Ansible"])
   tags = {
     Name = "${each.key}"
   }
}

resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "SSH access"
  vpc_id = aws_vpc.my-vpc.id

ingress {
    description = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
}
ingress {
    description = "Jenkins"
    from_port        = 8080
    to_port          = 8080
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

# VPC Block

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.1.0.0/16"
 tags = {
    Name = "my-vpc"
  }
}

# SUBNET Block(1)

resource "aws_subnet" "my-pub-subnet-01" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "my-pub-subnet-01"
  }
}
resource "aws_subnet" "my-pub-subnet-02" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "my-pub-subnet-02"
  }
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
 	Name = "my-igw"
  }
}
resource "aws_route_table" "my-pubrt" {
 vpc_id = aws_vpc.my-vpc.id
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}
}
resource "aws_route_table_association" "my-rta-public-subnet-01" {
subnet_id = aws_subnet.my-pub-subnet-01.id
route_table_id = aws_route_table.my-pubrt.id
}
resource "aws_route_table_association" "my-rta-public-subnet-02" {
subnet_id = aws_subnet.my-pub-subnet-02.id
route_table_id = aws_route_table.my-pubrt.id
}






