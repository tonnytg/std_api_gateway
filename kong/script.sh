#!/bin/bash

# Atualizar o sistema
sudo apt update -y
sudo apt upgrade -y

# Instalar dependências
sudo apt install -y curl software-properties-common

# Adicionar o repositório do Kong
echo "deb [arch=amd64] http://kong.bintray.com/kong-deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/kong.list
curl -fsSL https://download.konghq.com/gateway-3.x-ubuntu-$(lsb_release -cs).deb | sudo apt-key add -

# Atualizar novamente e instalar o Kong
sudo apt update -y
sudo apt install -y kong

# Configuração do Banco de Dados
echo "Configurando o Banco de Dados..."
sudo kong config db_reset --yes
sudo kong migrations bootstrap

# Iniciar o Kong
echo "Iniciando o Kong..."
sudo kong start

# Confirmar status do Kong
sudo kong health

echo "Instalação do Kong concluída. Verifique se o Kong está rodando acessando http://localhost:8001"

