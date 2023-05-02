provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami = "ami-0a72af05d27b49ccb"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}