# ===============================================
# 1. DATA SOURCE (Para obter a VPC Padrão automaticamente)
# ===============================================

data "aws_vpc" "default" {
  default = true
}

# ===============================================
# 2. SECURITY GROUP (Grupo de Segurança para liberar portas)
# ===============================================

resource "aws_security_group" "web_sg" {
  name        = "web_traffic_sg"
  # Correção: Descrição simples para evitar erro de caracteres
  description = "Allow HTTP and SSH traffic" 
  
  # Usa o ID da VPC Padrão encontrado acima
  vpc_id      = data.aws_vpc.default.id 

  # Regra de ENTRADA (Ingress) para HTTP (Porta 80)
  ingress {
    description = "HTTP de qualquer lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de ENTRADA (Ingress) para SSH (Porta 22)
  ingress {
    description = "SSH de qualquer lugar"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Regra de SAÍDA (Egress) - Permite todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

# ===============================================
# 3. AWS INSTANCE (Instância EC2 e Configuração do Servidor Web)
# ===============================================

resource "aws_instance" "web_server" {
  ami           = "ami-0341d95f75f311023" # AMI que você está usando
  instance_type = "t2.micro" 
  
  vpc_security_group_ids = [aws_security_group.web_sg.id] 
  
  tags = {
    Name = "ProjetoCloudJr"
  }

  # Script de inicialização (Corrigido para evitar falhas do shell e garantir update)
  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Cria e insere o conteúdo do seu index.html no diretório de serviço do Apache
cat > /var/www/html/index.html << EOL
<!DOCTYPE html>
<html>
<head>
<title>Meu Projeto Cloud 🚀</title>
</head>
<body>
<h1>Infraestrutura Cloud Automatizada com AWS e Terraform</h1>
<p>Projeto criado por Fabiana Alves Felisbino - Analista de Cloud Jr</p>
</body>
</html>
EOL
EOF
}