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
  name   = var.sg_name
  description = var.sg_description
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr
  }

  egress {
    from_port   = 0 # from 0 to 0 means, opening all protocols
    to_port     = 0
    protocol    = "-1" # -1 all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
    CreatedBy = "SathishReddy"
  }
}
# resource <resource-type> <resource-name>
resource "aws_instance" "db" {

    count = length(var.instance_names)
    ami                    = var.image_id
    instance_type = var.instance_names[count.index] == "db" ? "t3.small" : "t3.micro"
    vpc_security_group_ids = [aws_security_group.allow_shh.id]
    subnet_id              = aws_subnet.sub1.id

     # left side things are called as arguements, right side are values.
    tags = merge(
        var.common_tags,
        {
            Name = var.instance_names[count.index]
            Module = var.instance_names[count.index]
        }

    )
}
