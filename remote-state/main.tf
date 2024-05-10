resource "aws_instance" "db" {

    ami = "ami-090252cbe067a9e58"
    vpc_security_group_ids = ["sg-074c6f8bbe306fc73"]
    instance_type = "t3.micro"

    tags = {
        Name = "db"
    }
}