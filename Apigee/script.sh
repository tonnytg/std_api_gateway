#!/bin/bash

# Variáveis de configuração
PROJECT_ID="seu-projeto-id"
NETWORK_NAME="default"
APIGEE_ORG="nome-da-organizacao-apigee"
APIGEE_ENV="nome-do-ambiente-apigee"
RUNTIME_LOCATION="us-central1"  # Escolha a região apropriada

# Autenticar e configurar o projeto
gcloud auth login
gcloud config set project $PROJECT_ID

# Ativar APIs necessárias
echo "Ativando APIs necessárias..."
gcloud services enable apigee.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com

# Criar a organização Apigee
echo "Criando organização Apigee..."
gcloud alpha apigee organizations create \
    --project=$PROJECT_ID \
    --display-name=$APIGEE_ORG \
    --runtime-location=$RUNTIME_LOCATION \
    --analytics-region=$RUNTIME_LOCATION

# Associar a rede para comunicação privada
echo "Associando rede para comunicação privada..."
gcloud compute addresses create google-managed-services-$NETWORK_NAME \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=24 \
    --network=$NETWORK_NAME

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --network=$NETWORK_NAME \
    --ranges=google-managed-services-$NETWORK_NAME

# Configurar o ambiente do Apigee
echo "Configurando o ambiente do Apigee..."
gcloud apigee environments create \
    --organization=$APIGEE_ORG \
    --display-name=$APIGEE_ENV \
    --name=$APIGEE_ENV

# Esperar até que o ambiente esteja ativo
echo "Aguardando ativação do ambiente..."
sleep 60  # Ajuste o tempo de espera conforme necessário

# Conectar a VPC para rede privada (opcional, baseado na configuração do Apigee X)
echo "Configurando rede privada (opcional)..."
gcloud alpha apigee instances create \
    --organization=$APIGEE_ORG \
    --environment=$APIGEE_ENV \
    --name=apigee-instance \
    --location=$RUNTIME_LOCATION

# Configuração final
echo "Instalação e configuração do Apigee concluídas."
echo "Para acessar o Apigee, vá até o Console do Google Cloud em https://console.cloud.google.com/apigee"

