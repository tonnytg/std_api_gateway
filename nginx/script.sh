#!/bin/bash

# Detectar o sistema operacional
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Sistema operacional não suportado."
    exit 1
fi

# Função para instalar Nginx em sistemas Debian/Ubuntu
install_nginx_debian() {
    echo "Instalando o Nginx em um sistema Debian/Ubuntu..."
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
}

# Função para instalar Nginx em sistemas CentOS/RHEL
install_nginx_centos() {
    echo "Instalando o Nginx em um sistema CentOS/RHEL..."
    sudo yum install -y epel-release
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
}

# Instalação baseada no sistema operacional detectado
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    install_nginx_debian
elif [[ "$OS" == "centos" || "$OS" == "rhel" ]]; then
    install_nginx_centos
else
    echo "Sistema operacional não suportado."
    exit 1
fi

# Verificação do status do Nginx
echo "Verificando o status do Nginx..."
sudo systemctl status nginx --no-pager

echo "Instalação do Nginx concluída. Verifique o acesso no navegador em http://localhost (ou no IP do seu servidor)."

