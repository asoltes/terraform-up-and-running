output "public_ip" {
  value       = aws_instance.webserver.public_ip
  description = "public ip address of webserver instance"
}

output "public_dns" {
  value       = aws_instance.webserver.public_dns
  description = "public dns of webserver instance"
}