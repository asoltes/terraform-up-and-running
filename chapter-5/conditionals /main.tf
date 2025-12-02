## Create resource if the variable is set to true 1 is true and 0 is false.

resource "aws_instance" "main" {
  count         = var.enable_ec2 ? 1 : 0
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}