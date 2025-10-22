resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Deploy Automático com Terraform + AWS</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "ProjetoCloudJr"
  }
}
