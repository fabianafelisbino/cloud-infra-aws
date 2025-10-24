output "instance_ip" {
  description = "O IP público da instância EC2 web_server"
  value       = aws_instance.web_server.public_ip 
}