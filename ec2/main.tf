#1. command line
#2. tfvars
#3. ENV variable
#4. variable default value

# resource <resource-type> <resource-name>
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_security_group" "allow_shh" {
  name   = "allow_shh"
  description = "allowing SSH access"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 # from 0 to 0 means, opening all protocols
    to_port     = 0
    protocol    = "-1" # -1 all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    CreatedBy = "SathishReddy"
  }
}
# resource <resource-type> <resource-name>
resource "aws_instance" "db" {

    ami                    = "ami-090252cbe067a9e58"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_shh.id]
    subnet_id              = aws_subnet.sub1.id

     # left side things are called as arguements, right side are values.
    tags =var.tags
    
}