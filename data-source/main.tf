resource "aws_instance" "db" {

    ami = data.aws_ami.ami_id.id
    vpc_security_group_ids = ["sg-074c6f8bbe306fc73" ]
    instance_type = "t3.micro"
    tags = {
        Name = "data-source-practice"
    }
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  # Other VPC configuration options
}
