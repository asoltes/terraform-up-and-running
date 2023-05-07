resource "aws_instance" "webserver" {
  ami                         = "ami-0a72af05d27b49ccb"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webserver.id]
  user_data                   = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  user_data_replace_on_change = true
  tags = {
    Name = "one-webserver"
  }
}

resource "aws_security_group" "webserver" {
  name        = "Allow web"
  description = "Allow web inbound traffic"
  vpc_id      = "vpc-0609a33f6b97b90cd"

  ingress {
    description = "TLS from VPC"
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-web-traffic"
  }
}