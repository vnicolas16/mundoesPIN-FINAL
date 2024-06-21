#!/bin/bash

# Establecer región por defecto
AWS_REGION="us-east-1"
export AWS_REGION
AWS_DEFAULT_REGION="us-east-1"
export AWS_DEFAULT_REGION

# Cargar el nombre de la clave SSH
if [ -f /home/ubuntu/ssh_key_name.txt ]; then
  . /home/ubuntu/ssh_key_name.txt
else
  echo "Error: No se encontró el archivo /home/ubuntu/ssh_key_name.txt"
  exit 1
fi

# Verificar si KEY_NAME está vacío
if [ -z "$KEY_NAME" ]; then
  echo "Error: La clave SSH no está definida en /home/ubuntu/ssh_key_name.txt"
  exit 1
fi

# Verificar si la clave SSH existe en EC2
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" --region us-east-1 > /dev/null 2>&1; then
  echo "Error: La clave SSH $KEY_NAME no existe en EC2"
  exit 1
fi

# Crear el clúster EKS
echo "Creando el clúster EKS usando la clave SSH $KEY_NAME"
eksctl create cluster --name my-eks-cluster --version 1.21 --region $AWS_REGION --nodegroup-name standard-workers --node-type t2.micro --nodes 2 --nodes-min 1 --nodes-max 3 --ssh-access --ssh-public-key $KEY_NAME --managed
